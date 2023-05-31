import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? _user;
  List<String> _videoUrls = [];
  bool _loading = false;
  List<VideoPlayerController> _videoControllers = [];

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
    _fetchVideos();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _checkCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> _fetchVideos() async {
    setState(() {
      _loading = true;
    });

    try {
      QuerySnapshot snapshot = await _firestore.collection('videos').get();
      List<String> urls = snapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['videoUrl'] as String)
          .toList();

      setState(() {
        _videoUrls = urls;
        _loading = false;
      });

      // Initialize video player controllers
      _initializeVideoControllers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error occurred")));
      print(e.toString());
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _uploadVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);
      String filename = DateTime.now().microsecondsSinceEpoch.toString();

      try {
        setState(() {
          _loading = true;
        });

        Reference ref = _storage.ref().child('videos/$filename.mp4');
        UploadTask uploadTask = ref.putFile(videoFile);

        TaskSnapshot taskSnapshot = await uploadTask;
        String videoUrl = await taskSnapshot.ref.getDownloadURL();

        await _firestore.collection('videos').add({
          'userId': _user!.email,
          'videoUrl': videoUrl,
        });

        setState(() {
          _loading = false;
        });

        _fetchVideos();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error occurred")));
        print(e.toString());
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _initializeVideoControllers() {
    _videoControllers.clear();
    for (var url in _videoUrls) {
      VideoPlayerController controller = VideoPlayerController.network(url);

      _videoControllers.add(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Upload'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _videoUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (_videoControllers[index].value.isPlaying) {
                      _videoControllers[index].pause();
                    } else {
                      _videoControllers[index].play();
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayer(_videoControllers[index]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadVideo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
