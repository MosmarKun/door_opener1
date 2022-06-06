class Door {
  final String? bluetooth_mac;
  final String? description;
  final int? id;
  final bool? open_request;


  Door(this.bluetooth_mac, this.description, this.id,this.open_request);

  Door.fromJson(Map<String, dynamic> json)
      : bluetooth_mac = json['bluetooth_mac'],
        description = json['description'],
        id = json['id'],
        open_request = json['open_request'] ;




  Map<String, dynamic> toJson() => {
    'bluetooth_mac': bluetooth_mac,
    'description': description,
    'id' : id,
    'open_request' : open_request,

  };
}