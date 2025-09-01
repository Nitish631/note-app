import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteDialouge extends StatefulWidget {
  final int? noteId;
  final String? title;
  final String? content;
  final int colorIndex;
  final List<Color> noteColors;
  final Function onNoteSaved;
  const NoteDialouge({
    super.key,
    this.noteId,
    this.title,
    this.content,
    required this.colorIndex,
    required this.noteColors,
    required this.onNoteSaved,
  });

  @override
  State<NoteDialouge> createState() => _NoteDialougeState();
}

class _NoteDialougeState extends State<NoteDialouge> {
  late int _selectedColorIndex;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late FocusNode titleFocusNode;
  late FocusNode descriptionFocusNode;
  void initState(){
    super.initState();
    _selectedColorIndex=widget.colorIndex;
    titleController= TextEditingController(text:widget.title??"");
    descriptionController = TextEditingController(text:widget.content??"");
    titleFocusNode = FocusNode()..addListener(()=>setState(() {}));
    descriptionFocusNode =FocusNode()..addListener(()=>setState(() {}));
  }
  @override
  void dispose(){
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final currentDate=DateFormat("dd MM yyyy").format(DateTime.now());
    return AlertDialog(
      backgroundColor: widget.noteColors[_selectedColorIndex],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        widget.noteId==null? "Add Note" :"Edit Note",
        style: TextStyle(
          color: Colors.black87,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentDate,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: titleController,
              focusNode: titleFocusNode,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  filled: true,
                  // fillColor: MaterialStateColor.resolveWith((states){
                  //   if(states.contains(MaterialState.pressed)){
                  //     return Colors.white;
                  //   }
                  //   return Colors.white.withOpacity(0.9);
                  // }),
                  fillColor: titleFocusNode.hasFocus?Colors.white:Colors.white.withOpacity(0.5),
                  labelText: "Title",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  )

              ),
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: descriptionController,
              focusNode: descriptionFocusNode,
              maxLines: 13,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  filled: true,
                  // fillColor: MaterialStateColor.resolveWith((states){
                  //   if(states.contains(MaterialState.pressed)){
                  //     return Colors.white;
                  //   }
                  //   return Colors.white.withOpacity(0.5);
                  // }),
                  fillColor:descriptionFocusNode.hasFocus?Colors.white:Colors.white.withOpacity(0.5),
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.black),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  )
              ),
            ),
            const SizedBox(height: 16,),
            Wrap(
                spacing: 8,
                children:
                List.generate(
                    widget.noteColors.length,
                        (index)=>GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectedColorIndex=index;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: widget.noteColors[index],
                        radius: 16,
                        child: _selectedColorIndex==index
                            ? const Icon(Icons.check,color: Colors.black54,size: 16,):const Icon(Icons.radio_button_unchecked),
                      ),
                    )
                )
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            // titleController.clear();
            // descriptionController.clear();
            Navigator.pop(context);
          },
          style:TextButton.styleFrom(
            backgroundColor: Colors.deepOrange,
          ),
          child: const Text("Cancel",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )
          ),
          onPressed: ()async{
            final newTitle=titleController.text;
            final newDescription=descriptionController.text;
            widget.onNoteSaved(newTitle,newDescription,_selectedColorIndex,currentDate);
            // titleController.clear();
            // descriptionController.clear();
          },
          child: const Text(
            "Save",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}