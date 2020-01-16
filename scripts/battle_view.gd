extends Node2D

func remove_entity1():
    var childs = $entity1.get_children()
    for c in childs:
        $entity1.remove_child(c)

func remove_entity2():
    var childs = $entity2.get_children()
    for c in childs:
        $entity2.remove_child(c)
