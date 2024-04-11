///
///
/// this file contains:
///
/// [ListLinked]
/// [ListLinkedEntry]
///
///
part of damath_collection;

///
///
///
base class ListLinked<E extends LinkedListEntry<E>> extends LinkedList<E> {
  ListLinked();

  E operator [](int index) => elementAt(index);
}

///
///
///
base class ListLinkedEntry extends LinkedListEntry<ListLinkedEntry> {
  ListLinkedEntry();
}