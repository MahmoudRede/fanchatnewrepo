

class MessageModel{
  String? senderId;
  String? recevierId;
  String? dateTime;
  String? text;
  String? image;
  String? voice;

  MessageModel({
   this.senderId,
    this.recevierId,
    this.dateTime,
    this.text,
    this.image,
    this.voice
  });
  MessageModel.fromJson(Map<String , dynamic> json){
    senderId=json['senderId'];
    recevierId=json['recevierId'];
    dateTime=json['dateTime'];
    text=json['text'];
    image=json['image'];
    voice=json['voice'];
  }

  Map <String , dynamic> toMap(){
    return{
      'senderId':senderId,
      'recevierId':recevierId,
      'dateTime':dateTime,
      'text':text,
      'image':image,
      'voice':voice,
    };
  }
}