import 'package:flutter/material.dart';
class NoteCard extends StatelessWidget {
  final Map<String,dynamic> note;
  final Function onDelete;
  final Function onTap;
  final List<Color> noteColors;
  const NoteCard({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onTap,
    required this.noteColors
  });
  @override
  Widget build(BuildContext context) {
    final colorIndex=note['color'] as int;
    return GestureDetector(
      onTap:()=>onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: noteColors[colorIndex],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note['date'],
              style:const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              note['title'],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8,),
            Expanded(
              child:Text(
                note['desc'],
                style: TextStyle(
                    color: Colors.white,
                    height: 1.5
                ),
                overflow: TextOverflow.fade,
              ) ,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed:(){
                      showDialog(
                        context: context,
                         builder:(context)=>AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: const Text(
                            "Are you sure you want to delete this note?",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed:(){
                                Navigator.pop(context);
                              }, 
                              child: Text("Cancel",style: TextStyle(color: Colors.white),)
                              ),
                              ElevatedButton(onPressed: (){
                                onDelete();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child:const Text("Delete",style: TextStyle(color: Colors.white),),
                              )
                          ],
                         )
                         );
                    },
                    icon: Icon(Icons.delete_outline,color: Colors.black54,)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}