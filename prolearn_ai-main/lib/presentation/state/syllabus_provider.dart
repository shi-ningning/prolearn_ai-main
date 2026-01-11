import 'package:flutter/material.dart';
import '../../data/models/syllabus_model.dart';
import '../../data/repositories/syllabus_repository.dart';

class SyllabusProvider with ChangeNotifier {
  List<SyllabusModel> _syllabi = [];
  final SyllabusRepository _syllabusRepository = SyllabusRepository();

  List<SyllabusModel> get syllabi => _syllabi;

  Future<void> loadSyllabi() async {
    _syllabi = await _syllabusRepository.getSyllabi();
    notifyListeners();
  }

  Future<void> addSyllabus(SyllabusModel syllabus) async {
    await _syllabusRepository.saveSyllabus(syllabus);
    _syllabi.add(syllabus);
    notifyListeners();
  }
}
