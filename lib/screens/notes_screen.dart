import 'package:flutter/material.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/screens/note_card.dart';
import 'note_dialogue.dart';
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String,dynamic>> notes=[];
  List<Color> noteColors=[
    const Color(0xFFE1BEE7), // corrected purple shade
    // const Color(0xFFF3E5F5), // valid (lavender)
    const Color(0xFFFCE4EC), // valid (pink)
    const Color(0xFF89CFF0), // baby blue
    const Color(0xFFFBAAB8), // rose pink
    const Color(0xFFB2F9FC), // sky blue
    const Color(0xFFFFD59A), // peach
    const Color(0xFFFFE5B4), // light orange
    const Color(0xFF98FB98), // pale green
    const Color(0xFFFFD700), // gold
    // const Color(0xFFFAFEEE), // mint cream
    const Color(0xFFB0C4DE), // light steel blue
    const Color(0xFFFFA500), // orange
    const Color(0xFF00F5FE), // cyan corrected
  ];
  @override
  void initState(){
    super.initState();
    fetchNotes();
  }
  Future<void> fetchNotes() async{
    final fetchedNotes=await NoteDatabase.instance.getNotes();
    setState(() {
      notes=fetchedNotes;
    });
  }
  void showNoteDialog({int? id,String? title,String? content,int colorIndex=0}){
    showDialog(context: context,
        builder:(dialogContext){
          return NoteDialouge(
            colorIndex: colorIndex,
            noteColors: noteColors,
            noteId: id,
            title: title,
            content: content,
            onNoteSaved: (newTitle,newDEscriiption,newColorIndex,currentDate,)async{
              Navigator.pop(dialogContext);
              if(id==null){
                await NoteDatabase.instance.addNote(newTitle, newDEscriiption, newColorIndex, currentDate);
              }else{
                await NoteDatabase.instance.updateNote(newTitle,newDEscriiption,currentDate,newColorIndex,id);
              }
              await fetchNotes();
            },
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("NOTES",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:Color.fromRGBO(0, 213, 255, 1),
            fontSize: 30,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showNoteDialog();
        },
        backgroundColor: Color.fromRGBO(0,213,255,1),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      body: notes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notes_outlined,
              size: 100,
              color: Colors.blueAccent.shade100,
            ),
            SizedBox(height: 20,),
            Text(
              "No Notes yet",
              style: TextStyle(
                fontSize: 20,
                color:Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ):
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85
          ),
          itemCount: notes.length,
          itemBuilder: (context,index){
            final note= notes[index];
            return NoteCard(
                note: note,
                onDelete: ()async{
                  await NoteDatabase.instance.deleteNote(note['id']);
                  fetchNotes();
                },
                onTap:(){
                  showNoteDialog(
                      id: note['id'],
                      title: note['title'],
                      content: note['desc'],
                      colorIndex: note['color']
                  );
                },
                noteColors: noteColors
            );
          },
        ),
      ),
    );
  }
}