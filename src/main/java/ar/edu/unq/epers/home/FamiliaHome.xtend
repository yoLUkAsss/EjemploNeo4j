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
	
	def crearNodo(Persona persona) {
		val node = this.graph.createNode(personLabel)
		node.setProperty("dni", persona.dni)
		node.setProperty("nombre", persona.nombre)
		node.setProperty("apellido", persona.apellido)
	}

	def eliminarNodo(Persona persona) {
		val nodo = this.getNodo(persona)
		nodo.relationships.forEach[delete]
		nodo.delete
	}

	def getNodo(Persona persona) {
		this.getNodo(persona.dni)
	}
	
	def getNodo(String dni) {
		this.graph.findNodes(personLabel, "dni", dni).head
	}
	
	def relacionar(Persona persona1, Persona persona2, TipoDeRelaciones relacion) {
		val nodo1 = this.getNodo(persona1);
		val nodo2 = this.getNodo(persona2);
		nodo1.createRelationshipTo(nodo2, relacion);
	}
	
	
	private def toPersona(Node nodo) {
		new Persona => [
			dni = nodo.getProperty("dni") as String
			nombre = nodo.getProperty("nombre") as String
			apellido = nodo.getProperty("apellido") as String
		]
	}

	def getPadres(Persona persona) {
		val nodoPersona = this.getNodo(persona)
		val nodoPadres = this.nodosRelacionados(nodoPersona, TipoDeRelaciones.PADRE, Direction.INCOMING)
		nodoPadres.map[toPersona].toSet
	}

	def getHermanos(Persona persona) {
		val nodoPersona = this.getNodo(persona)
		val nodoHermanos = this.nodosRelacionados(nodoPersona, TipoDeRelaciones.HERMANO, Direction.INCOMING)
		nodoHermanos.map[toPersona].toSet
	}

	def getHijos(Persona persona) {
		val nodoPersona = this.getNodo(persona)
		val nodoPadres = this.nodosRelacionados(nodoPersona, TipoDeRelaciones.HIJO, Direction.INCOMING)
		nodoPadres.map[toPersona].toSet
	}
	
	def getPrimos(Persona persona) {
		val tios = this.getPadres(persona).map[getHermanos(it)].flatten
		tios.map[this.getHijos(it)].flatten.toSet
	}

	protected def nodosRelacionados(Node nodo, RelationshipType tipo, Direction direccion) {
		nodo.getRelationships(tipo, direccion).map[it.getOtherNode(nodo)]
	}

}