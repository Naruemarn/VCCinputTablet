// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SQLiteModelVccCastLog {
  final String timestamp;  
  final String machine_name;
  final String serial;
  final String recipe_name;

  final String job_id;
  final String design_code;
  final String alloy;
  final String flask_temp;
  final String weight;

  final String wax;
  final String wax_3d;
  final String resin;

  final String mode1;
  final String temp_setting_value;
  final String max_heat_power;
  final String inert_gas;
  final String airwash;
  final String s_curve;
  final String acceleration;
  final String rotation;
  final String pressure_pv;
  final String rotation_time;
  final String exh_timing;

  final String mode2;
  final String origin_point;
  final String arm_origin_speed;
  final String zero_point_adjust;
  final String laser_light;
  final String emissivity;
  final String casting_keep_time;
  final String casting_range_degree;
  final String p;
  final String i;
  final String d;
  SQLiteModelVccCastLog({
    required this.timestamp,
    required this.machine_name,
    required this.serial,
    required this.recipe_name,
    required this.job_id,
    required this.design_code,
    required this.alloy,
    required this.flask_temp,
    required this.weight,
    required this.wax,
    required this.wax_3d,
    required this.resin,
    required this.mode1,
    required this.temp_setting_value,
    required this.max_heat_power,
    required this.inert_gas,
    required this.airwash,
    required this.s_curve,
    required this.acceleration,
    required this.rotation,
    required this.pressure_pv,
    required this.rotation_time,
    required this.exh_timing,
    required this.mode2,
    required this.origin_point,
    required this.arm_origin_speed,
    required this.zero_point_adjust,
    required this.laser_light,
    required this.emissivity,
    required this.casting_keep_time,
    required this.casting_range_degree,
    required this.p,
    required this.i,
    required this.d,
  });

  SQLiteModelVccCastLog copyWith({
    String? timestamp,
    String? machine_name,
    String? serial,
    String? recipe_name,
    String? job_id,
    String? design_code,
    String? alloy,
    String? flask_temp,
    String? weight,
    String? wax,
    String? wax_3d,
    String? resin,
    String? mode1,
    String? temp_setting_value,
    String? max_heat_power,
    String? inert_gas,
    String? airwash,
    String? s_curve,
    String? acceleration,
    String? rotation,
    String? pressure_pv,
    String? rotation_time,
    String? exh_timing,
    String? mode2,
    String? origin_point,
    String? arm_origin_speed,
    String? zero_point_adjust,
    String? laser_light,
    String? emissivity,
    String? casting_keep_time,
    String? casting_range_degree,
    String? p,
    String? i,
    String? d,
  }) {
    return SQLiteModelVccCastLog(
      timestamp: timestamp ?? this.timestamp,
      machine_name: machine_name ?? this.machine_name,
      serial: serial ?? this.serial,
      recipe_name: recipe_name ?? this.recipe_name,
      job_id: job_id ?? this.job_id,
      design_code: design_code ?? this.design_code,
      alloy: alloy ?? this.alloy,
      flask_temp: flask_temp ?? this.flask_temp,
      weight: weight ?? this.weight,
      wax: wax ?? this.wax,
      wax_3d: wax_3d ?? this.wax_3d,
      resin: resin ?? this.resin,
      mode1: mode1 ?? this.mode1,
      temp_setting_value: temp_setting_value ?? this.temp_setting_value,
      max_heat_power: max_heat_power ?? this.max_heat_power,
      inert_gas: inert_gas ?? this.inert_gas,
      airwash: airwash ?? this.airwash,
      s_curve: s_curve ?? this.s_curve,
      acceleration: acceleration ?? this.acceleration,
      rotation: rotation ?? this.rotation,
      pressure_pv: pressure_pv ?? this.pressure_pv,
      rotation_time: rotation_time ?? this.rotation_time,
      exh_timing: exh_timing ?? this.exh_timing,
      mode2: mode2 ?? this.mode2,
      origin_point: origin_point ?? this.origin_point,
      arm_origin_speed: arm_origin_speed ?? this.arm_origin_speed,
      zero_point_adjust: zero_point_adjust ?? this.zero_point_adjust,
      laser_light: laser_light ?? this.laser_light,
      emissivity: emissivity ?? this.emissivity,
      casting_keep_time: casting_keep_time ?? this.casting_keep_time,
      casting_range_degree: casting_range_degree ?? this.casting_range_degree,
      p: p ?? this.p,
      i: i ?? this.i,
      d: d ?? this.d,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestamp': timestamp,
      'machine_name': machine_name,
      'serial': serial,
      'recipe_name': recipe_name,
      'job_id': job_id,
      'design_code': design_code,
      'alloy': alloy,
      'flask_temp': flask_temp,
      'weight': weight,
      'wax': wax,
      'wax_3d': wax_3d,
      'resin': resin,
      'mode1': mode1,
      'temp_setting_value': temp_setting_value,
      'max_heat_power': max_heat_power,
      'inert_gas': inert_gas,
      'airwash': airwash,
      's_curve': s_curve,
      'acceleration': acceleration,
      'rotation': rotation,
      'pressure_pv': pressure_pv,
      'rotation_time': rotation_time,
      'exh_timing': exh_timing,
      'mode2': mode2,
      'origin_point': origin_point,
      'arm_origin_speed': arm_origin_speed,
      'zero_point_adjust': zero_point_adjust,
      'laser_light': laser_light,
      'emissivity': emissivity,
      'casting_keep_time': casting_keep_time,
      'casting_range_degree': casting_range_degree,
      'p': p,
      'i': i,
      'd': d,
    };
  }

  factory SQLiteModelVccCastLog.fromMap(Map<String, dynamic> map) {
    return SQLiteModelVccCastLog(
      timestamp: map['timestamp'] as String,
      machine_name: map['machine_name'] as String,
      serial: map['serial'] as String,
      recipe_name: map['recipe_name'] as String,
      job_id: map['job_id'] as String,
      design_code: map['design_code'] as String,
      alloy: map['alloy'] as String,
      flask_temp: map['flask_temp'] as String,
      weight: map['weight'] as String,
      wax: map['wax'] as String,
      wax_3d: map['wax_3d'] as String,
      resin: map['resin'] as String,
      mode1: map['mode1'] as String,
      temp_setting_value: map['temp_setting_value'] as String,
      max_heat_power: map['max_heat_power'] as String,
      inert_gas: map['inert_gas'] as String,
      airwash: map['airwash'] as String,
      s_curve: map['s_curve'] as String,
      acceleration: map['acceleration'] as String,
      rotation: map['rotation'] as String,
      pressure_pv: map['pressure_pv'] as String,
      rotation_time: map['rotation_time'] as String,
      exh_timing: map['exh_timing'] as String,
      mode2: map['mode2'] as String,
      origin_point: map['origin_point'] as String,
      arm_origin_speed: map['arm_origin_speed'] as String,
      zero_point_adjust: map['zero_point_adjust'] as String,
      laser_light: map['laser_light'] as String,
      emissivity: map['emissivity'] as String,
      casting_keep_time: map['casting_keep_time'] as String,
      casting_range_degree: map['casting_range_degree'] as String,
      p: map['p'] as String,
      i: map['i'] as String,
      d: map['d'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModelVccCastLog.fromJson(String source) => SQLiteModelVccCastLog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SQLiteModelVccCastLog(timestamp: $timestamp, machine_name: $machine_name, serial: $serial, recipe_name: $recipe_name, job_id: $job_id, design_code: $design_code, alloy: $alloy, flask_temp: $flask_temp, weight: $weight, wax: $wax, wax_3d: $wax_3d, resin: $resin, mode1: $mode1, temp_setting_value: $temp_setting_value, max_heat_power: $max_heat_power, inert_gas: $inert_gas, airwash: $airwash, s_curve: $s_curve, acceleration: $acceleration, rotation: $rotation, pressure_pv: $pressure_pv, rotation_time: $rotation_time, exh_timing: $exh_timing, mode2: $mode2, origin_point: $origin_point, arm_origin_speed: $arm_origin_speed, zero_point_adjust: $zero_point_adjust, laser_light: $laser_light, emissivity: $emissivity, casting_keep_time: $casting_keep_time, casting_range_degree: $casting_range_degree, p: $p, i: $i, d: $d)';
  }

  @override
  bool operator ==(covariant SQLiteModelVccCastLog other) {
    if (identical(this, other)) return true;
  
    return 
      other.timestamp == timestamp &&
      other.machine_name == machine_name &&
      other.serial == serial &&
      other.recipe_name == recipe_name &&
      other.job_id == job_id &&
      other.design_code == design_code &&
      other.alloy == alloy &&
      other.flask_temp == flask_temp &&
      other.weight == weight &&
      other.wax == wax &&
      other.wax_3d == wax_3d &&
      other.resin == resin &&
      other.mode1 == mode1 &&
      other.temp_setting_value == temp_setting_value &&
      other.max_heat_power == max_heat_power &&
      other.inert_gas == inert_gas &&
      other.airwash == airwash &&
      other.s_curve == s_curve &&
      other.acceleration == acceleration &&
      other.rotation == rotation &&
      other.pressure_pv == pressure_pv &&
      other.rotation_time == rotation_time &&
      other.exh_timing == exh_timing &&
      other.mode2 == mode2 &&
      other.origin_point == origin_point &&
      other.arm_origin_speed == arm_origin_speed &&
      other.zero_point_adjust == zero_point_adjust &&
      other.laser_light == laser_light &&
      other.emissivity == emissivity &&
      other.casting_keep_time == casting_keep_time &&
      other.casting_range_degree == casting_range_degree &&
      other.p == p &&
      other.i == i &&
      other.d == d;
  }

  @override
  int get hashCode {
    return timestamp.hashCode ^
      machine_name.hashCode ^
      serial.hashCode ^
      recipe_name.hashCode ^
      job_id.hashCode ^
      design_code.hashCode ^
      alloy.hashCode ^
      flask_temp.hashCode ^
      weight.hashCode ^
      wax.hashCode ^
      wax_3d.hashCode ^
      resin.hashCode ^
      mode1.hashCode ^
      temp_setting_value.hashCode ^
      max_heat_power.hashCode ^
      inert_gas.hashCode ^
      airwash.hashCode ^
      s_curve.hashCode ^
      acceleration.hashCode ^
      rotation.hashCode ^
      pressure_pv.hashCode ^
      rotation_time.hashCode ^
      exh_timing.hashCode ^
      mode2.hashCode ^
      origin_point.hashCode ^
      arm_origin_speed.hashCode ^
      zero_point_adjust.hashCode ^
      laser_light.hashCode ^
      emissivity.hashCode ^
      casting_keep_time.hashCode ^
      casting_range_degree.hashCode ^
      p.hashCode ^
      i.hashCode ^
      d.hashCode;
  }
}
