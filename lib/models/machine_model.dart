// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MachineModel {
  final String machine_name;
  final String serial;
  MachineModel({
    required this.machine_name,
    required this.serial,
  });

  MachineModel copyWith({
    String? machine_name,
    String? serial,
  }) {
    return MachineModel(
      machine_name: machine_name ?? this.machine_name,
      serial: serial ?? this.serial,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'machine_name': machine_name,
      'serial': serial,
    };
  }

  factory MachineModel.fromMap(Map<String, dynamic> map) {
    return MachineModel(
      machine_name: map['machine_name'] as String,
      serial: map['serial'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MachineModel.fromJson(String source) => MachineModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MachineModel(machine_name: $machine_name, serial: $serial)';

  @override
  bool operator ==(covariant MachineModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.machine_name == machine_name &&
      other.serial == serial;
  }

  @override
  int get hashCode => machine_name.hashCode ^ serial.hashCode;
}
