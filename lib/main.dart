import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'student.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _mataKuliahController = TextEditingController();
  final TextEditingController _nilaiUasController = TextEditingController();
  final TextEditingController _nilaiUtsController = TextEditingController();
  late bool _isEditing;
  late int _editingStudentId;

  @override
  void initState() {
    super.initState();
    _isEditing = false;
    _editingStudentId = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UAS ELFIRA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? 'Edit Data' : 'Tambah Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _nimController,
              decoration: InputDecoration(labelText: 'NIM'),
            ),
            TextField(
              controller: _mataKuliahController,
              decoration: InputDecoration(labelText: 'Mata Kuliah'),
            ),
            TextField(
              controller: _nilaiUasController,
              decoration: InputDecoration(labelText: 'Nilai UAS'),
            ),
            TextField(
              controller: _nilaiUtsController,
              decoration: InputDecoration(labelText: 'Nilai UTS'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isEditing ? _updateStudent : _addStudent,
                  child: Text(_isEditing ? 'Simpan Perubahan' : 'Tambah'),
                ),
                SizedBox(width: 16),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: _cancelEditing,
                    child: Text('Batal'),
                  ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Data Mahasiswa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<List<Student>>(
                future: _databaseHelper.getStudents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var student = snapshot.data![index];
                        return ListTile(
                          title: Text(student.nama),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('NIM: ${student.nim}'),
                              Text('Mata Kuliah: ${student.mataKuliah}'),
                              Text('Nilai UAS: ${student.nilaiUAS}'),
                              Text('Nilai UTS: ${student.nilaiUTS}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editStudent(student);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await _databaseHelper
                                      .deleteStudent(student.id!);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addStudent() async {
    await _databaseHelper.insertStudent(Student(
      nama: _namaController.text,
      nim: int.tryParse(_nimController.text) ?? 0,
      mataKuliah: _mataKuliahController.text,
      nilaiUAS: double.tryParse(_nilaiUasController.text) ?? 0.0,
      nilaiUTS: double.tryParse(_nilaiUtsController.text) ?? 0.0,
    ));
    setState(() {
      _namaController.clear();
      _nimController.clear();
      _mataKuliahController.clear();
      _nilaiUasController.clear();
      _nilaiUtsController.clear();
    });
  }

  void _editStudent(Student student) {
    setState(() {
      _isEditing = true;
      _editingStudentId = student.id!;
      _namaController.text = student.nama;
      _nimController.text = student.nim.toString();
      _mataKuliahController.text = student.mataKuliah;
      _nilaiUasController.text = student.nilaiUAS.toString();
      _nilaiUtsController.text = student.nilaiUTS.toString();
    });
  }

  void _updateStudent() async {
    await _databaseHelper.updateStudent(Student(
      id: _editingStudentId,
      nama: _namaController.text,
      nim: int.tryParse(_nimController.text) ?? 0,
      mataKuliah: _mataKuliahController.text,
      nilaiUAS: double.tryParse(_nilaiUasController.text) ?? 0.0,
      nilaiUTS: double.tryParse(_nilaiUtsController.text) ?? 0.0,
    ));
    setState(() {
      _isEditing = false;
      _editingStudentId = 0;
      _namaController.clear();
      _nimController.clear();
      _mataKuliahController.clear();
      _nilaiUasController.clear();
      _nilaiUtsController.clear();
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _editingStudentId = 0;
      _namaController.clear();
      _nimController.clear();
      _mataKuliahController.clear();
      _nilaiUasController.clear();
      _nilaiUtsController.clear();
    });
  }
}
