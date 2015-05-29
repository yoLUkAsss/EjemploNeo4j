package ar.edu.unq.epers.home

import ar.edu.unq.epers.model.Persona
import ar.edu.unq.epers.model.TipoDeRelaciones
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.DynamicLabel
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.RelationshipType

@Accessors
class FamiliaHome {
	GraphDatabaseService graph

	new(GraphDatabaseService graph) {
		this.graph = graph
	}

	def personLabel() {
		DynamicLabel.label("Person")
	}

	def eliminarNodo(Persona persona) {
		val nodo = getNodo(persona)
		nodo.relationships.forEach[delete]
		nodo.delete
	}

	def getNodo(Persona persona) {
		graph.findNodes(personLabel, "dni", persona.dni).head
	}

	def crearNodo(Persona persona) {
		val node = graph.createNode(personLabel)
		node.setProperty("dni", persona.dni)
		node.setProperty("nombre", persona.nombre)
		node.setProperty("apellido", persona.apellido)
	}

	def crearPersona(Node nodo) {
		new Persona => [
			dni = nodo.getProperty("dni") as String
			nombre = nodo.getProperty("nombre") as String
			apellido = nodo.getProperty("apellido") as String
		]
	}

	def padreDe(Persona padre, Persona hijo) {
		val padreNode = getNodo(padre)
		val hijoNode = getNodo(hijo)
		padreNode.createRelationshipTo(hijoNode, TipoDeRelaciones.PADRE);
		hijoNode.createRelationshipTo(padreNode, TipoDeRelaciones.HIJO);
	}

	def hermanos(Persona hermano1, Persona hermano2) {
		val hermano1Node = getNodo(hermano1)
		val hermano2Node = getNodo(hermano2)
		hermano1Node.createRelationshipTo(hermano2Node, TipoDeRelaciones.HERMANO);
		hermano2Node.createRelationshipTo(hermano1Node, TipoDeRelaciones.HERMANO);
	}

	def padres(Persona persona) {
		nodosRelacionados(getNodo(persona), TipoDeRelaciones.PADRE, Direction.INCOMING)
	}

	def hermanos(Persona persona) {
		hermanos(getNodo(persona))
	}

	def hermanos(Node nodo) {
		nodosRelacionados(nodo, TipoDeRelaciones.HERMANO, Direction.OUTGOING)
	}

	def hijos(Persona persona) {
		hijos(getNodo(persona))
	}

	def hijos(Node nodo) {
		nodosRelacionados(nodo, TipoDeRelaciones.HIJO, Direction.INCOMING)
	}

	protected def nodosRelacionados(Node nodo, RelationshipType tipo, Direction direccion) {
		nodo.getRelationships(tipo, direccion).map[it.getOtherNode(nodo)]
	}

	def primosDe(Persona persona) {
		val tios = padres(persona).map[hermanos].flatten
		tios.map[hijos].flatten.map[crearPersona].toList
	}
}