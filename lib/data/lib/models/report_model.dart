import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class SurvivorReport extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String survivorName;
  @HiveField(2) String sexuality;
  @HiveField(3) String age;
  @HiveField(4) String phone1;
  @HiveField(5) String phone2;
  @HiveField(6) String need; // This is sector
  @HiveField(7) String locationTag;
  @HiveField(8) double? lat;
  @HiveField(9) double? lng;
  @HiveField(10) String? photoPath;
  @HiveField(11) String? voicePath;
  @HiveField(12) String? videoPath;
  @HiveField(13) DateTime createdAt;
  @HiveField(14) String status;
  @HiveField(15) String assignedTotId;
  @HiveField(16) String description;
  SurvivorReport({required this.id, required this.survivorName, required this.sexuality, required this.age, required this.phone1, required this.phone2, required this.need, required this.locationTag, this.lat, this.lng, this.photoPath, this.voicePath, this.videoPath, required this.createdAt, this.status='pending', this.assignedTotId='', this.description=''});
}

@HiveType(typeId: 1)
class TOTReport extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String totId;
  @HiveField(2) String totName;
  @HiveField(3) String date;
  @HiveField(4) String time;
  @HiveField(5) String place;
  @HiveField(6) String survivorName;
  @HiveField(7) String incident;
  @HiveField(8) String policeOB;
  @HiveField(9) String actions;
  @HiveField(10) DateTime createdAt;
  @HiveField(11) String sector;
  TOTReport({required this.id, required this.totId, required this.totName, required this.date, required this.time, required this.place, required this.survivorName, required this.incident, required this.policeOB, required this.actions, required this.createdAt, this.sector='GBV / Violence'});
}

@HiveType(typeId: 2)
class Review extends HiveObject {
  @HiveField(0) String totId;
  @HiveField(1) double rating;
  @HiveField(2) String comment;
  Review({required this.totId, required this.rating, required this.comment});
}

class SurvivorReportAdapter extends TypeAdapter<SurvivorReport> {
  @override final typeId = 0;
  @override SurvivorReport read(BinaryReader r) => SurvivorReport(id: r.read(), survivorName: r.read(), sexuality: r.read(), age: r.read(), phone1: r.read(), phone2: r.read(), need: r.read(), locationTag: r.read(), lat: r.read(), lng: r.read(), photoPath: r.read(), voicePath: r.read(), videoPath: r.read(), createdAt: r.read(), status: r.read(), assignedTotId: r.read(), description: r.read());
  @override void write(BinaryWriter w, SurvivorReport o){w.write(o.id);w.write(o.survivorName);w.write(o.sexuality);w.write(o.age);w.write(o.phone1);w.write(o.phone2);w.write(o.need);w.write(o.locationTag);w.write(o.lat);w.write(o.lng);w.write(o.photoPath);w.write(o.voicePath);w.write(o.videoPath);w.write(o.createdAt);w.write(o.status);w.write(o.assignedTotId);w.write(o.description);}
}
class TOTReportAdapter extends TypeAdapter<TOTReport> {
  @override final typeId = 1;
  @override TOTReport read(BinaryReader r) => TOTReport(id: r.read(), totId: r.read(), totName: r.read(), date: r.read(), time: r.read(), place: r.read(), survivorName: r.read(), incident: r.read(), policeOB: r.read(), actions: r.read(), createdAt: r.read(), sector: r.read());
  @override void write(BinaryWriter w, TOTReport o){w.write(o.id);w.write(o.totId);w.write(o.totName);w.write(o.date);w.write(o.time);w.write(o.place);w.write(o.survivorName);w.write(o.incident);w.write(o.policeOB);w.write(o.actions);w.write(o.createdAt);w.write(o.sector);}
}
class ReviewAdapter extends TypeAdapter<Review> {
  @override final typeId = 2;
  @override Review read(BinaryReader r) => Review(totId: r.read(), rating: r.read(), comment: r.read());
  @override void write(BinaryWriter w, Review o){w.write(o.totId);w.write(o.rating);w.write(o.comment);}
}
