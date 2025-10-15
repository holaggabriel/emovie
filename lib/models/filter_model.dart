enum FilterType { language, releaseYear }

class FilterModel {
  final String filterValue;  // Valor que se compara en la propiedad de MovieModel
  final String name;         // Texto que se muestra en la UI
  final FilterType type;     // Tipo de filtro

  const FilterModel({
    required this.filterValue,
    required this.name,
    required this.type,
  });
}