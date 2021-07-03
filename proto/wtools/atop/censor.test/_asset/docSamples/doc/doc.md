## Introduction

The article describes the main principles of the module and shows how to use it.

```js
var scene = gl.Scene();
var node1 = gl.Node();
```

### Node and Scene

A scene is a root object in the tree hierarchy rendered by the engine. A node can represent a geometrical object, background, camera, light, spectator, etc. Each node may have many children but only a single parent, it's a tree.

The scene object is a container for other nodes and one may

 - Add node(s) to the tree
 - Remove node(s) from the tree
 - Traverse nodes tree

Simple example of creation of an instance of the scene and adding single node to the tree:

{:f::set( samplesPath : ../sample ):}

```js
var scene = gl.Scene();
var node = gl.Node();
scene.append( node );
console.log( 'Number of child nodes:', scene.children.length );
/* log: Number of child nodes: 1 */
```

Instances of `Scene` and instance of class `Node` are created. Node `node` is appended as a child to the `scene`. Scene `scene` now contains a single child node.

[Full sample]( {:f::sample_prev_path:} )
<!-- [Full sample](../../sample/scene/1_NodeAndScene.s) -->

### Node removal

Child node may be removed from the scene:

- Using the method `remove` of the parent node
- Using the method `remoteItself` of the child node
- Using the method `removeAll` of the parent node

**Single node removal.**

```js
var scene = gl.Scene();
var node1 = gl.Node();
scene.append( node1 );
console.log( 'Number of child nodes:', scene.children.length );
/* log: Number of child nodes: 1 */
scene.remove( node1 )
console.log( 'Number of child nodes:', scene.children.length );
/* log: Number of child nodes: 0 */
```

First, node `node1` is added to the `scene`, after what scene `scene` contains a single child node. Then, the node `node1` is removed from the `scene`. Scene `scene` now contains zero child nodes.

[Full sample](../../sample/scene/2_NodeRemove.s)

**Example of self-removal.**

```js
var scene = gl.Scene();
var node1 = gl.Node();
scene.append( node1 );
console.log( 'Number of child nodes:', scene.children.length );
/* log: Number of child nodes: 1 */
node1.removeItself()
console.log( 'Number of child nodes:', scene.children.length );
/* log: Number of child nodes: 0 */
```

Node `node1` is added to the `scene`. Scene `scene` now contains a single child node. Then node `node1` disconnected itself from the parent node. Parent `scene` now contains zero child nodes.

[Full sample](../../sample/scene/3_NodeRemoveItself.s)

**Removing all children.**

```js
var scene = gl.Scene();
var node1 = gl.Node();
var node2 = gl.Node();
scene.append( node1 );
scene.append( node2 );
console.log( 'Number of child nodes:', scene.children.length );
/* log: Number of child nodes: 2 */
scene.removeAll();
console.log( 'Number of child nodes:', scene.children.length );
/* log: Number of child nodes: 0 */
```

Nodes `node1` and `node2` are added to the `scene`. Scene `scene` now contains two child nodes. Scene `scene` removed references to all child nodes. Scene `scene` now contains zero child nodes.

[Full sample](../../sample/scene/4_NodeRemoveAll.s)
