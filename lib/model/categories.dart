class Category {
  int id;
  String name;
  String description;  
  int catcolor;

  categoryMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;
    mapping['catcolor'] = catcolor;


    return mapping;
  }


}