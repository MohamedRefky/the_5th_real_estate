import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/data/filters/apartment_filter.dart';
import 'package:the_5th_real_estate/models/apartment.dart';
import 'package:the_5th_real_estate/models/filter_values.dart';

Apartment _apt({
  String id = 'id',
  String title = 'جاردنيا هايتس',
  String description = 'شقة فاخرة',
  double price = 1000000,
  int floor = 1,
  FinishingStatus finishingStatus = FinishingStatus.superLux,
  ApartmentOrientation orientation = ApartmentOrientation.front,
  int rooms = 3,
  int bathrooms = 2,
  double areaSqm = 150,
}) {
  return Apartment(
    id: id,
    title: title,
    description: description,
    area: 'المستثمرين',
    price: price,
    floor: floor,
    totalFloors: 6,
    areaSqm: areaSqm,
    rooms: rooms,
    bathrooms: bathrooms,
    finishingStatus: finishingStatus,
    orientation: orientation,
    whatsappNumber: '+201000000000',
  );
}

void main() {
  final apartments = [
    _apt(id: 'a', price: 500000, floor: 1, rooms: 2, areaSqm: 115),
    _apt(id: 'b', price: 1200000, floor: 3, rooms: 3, areaSqm: 150),
    _apt(
      id: 'c',
      price: 2500000,
      floor: 6,
      rooms: 4,
      bathrooms: 3,
      areaSqm: 220,
      orientation: ApartmentOrientation.rear,
      finishingStatus: FinishingStatus.semiFinished,
    ),
  ];

  test('returns all when no filters', () {
    final result = filterApartments(
      source: apartments,
      filters: const FilterValues(),
    );
    expect(result.length, 3);
  });

  test('filters by price range', () {
    final result = filterApartments(
      source: apartments,
      filters: const FilterValues(minPrice: 600000, maxPrice: 2000000),
    );
    expect(result.map((a) => a.id), ['b']);
  });

  test('filters by floors', () {
    final result = filterApartments(
      source: apartments,
      filters: const FilterValues(floors: {1, 3}),
    );
    expect(result.map((a) => a.id), ['a', 'b']);
  });

  test('filters by finishing status', () {
    final result = filterApartments(
      source: apartments,
      filters: const FilterValues(finishingStatuses: {'semiFinished'}),
    );
    expect(result.map((a) => a.id), ['c']);
  });

  test('filters by orientation', () {
    final result = filterApartments(
      source: apartments,
      filters: const FilterValues(orientations: {ApartmentOrientation.rear}),
    );
    expect(result.map((a) => a.id), ['c']);
  });

  test('filters by rooms', () {
    final result = filterApartments(
      source: apartments,
      filters: const FilterValues(rooms: {2}),
    );
    expect(result.map((a) => a.id), ['a']);
  });

  test('filters by bathrooms', () {
    final result = filterApartments(
      source: apartments,
      filters: const FilterValues(bathrooms: {2}),
    );
    expect(result.map((a) => a.id), ['a', 'b']);
  });

  test('filters by area range', () {
    final result = filterApartments(
      source: apartments,
      filters: FilterValues(areaRanges: {(150.0, 200.0)}),
    );
    expect(result.map((a) => a.id), ['b']);
  });

  test('combines multiple filters', () {
    final result = filterApartments(
      source: apartments,
      filters: const FilterValues(
        minPrice: 1000000,
        maxPrice: 10000000,
        floors: {3, 6},
        rooms: {3, 4},
        finishingStatuses: {'semiFinished'},
      ),
    );
    expect(result.map((a) => a.id), ['c']);
  });

  test('matches search query by title', () {
    final result = filterApartments(
      source: apartments,
      filters: const FilterValues(),
      searchQuery: 'جاردنيا',
    );
    expect(result.length, 3);
  });

  test('matches search query by description', () {
    final result = filterApartments(
      source: apartments,
      filters: const FilterValues(),
      searchQuery: 'فاخرة',
    );
    expect(result.length, 3);
  });

  test('empty result when nothing matches', () {
    final noMatch = filterApartments(
      source: apartments,
      filters: const FilterValues(minPrice: 50000000),
    );
    expect(noMatch, isEmpty);
  });
}
