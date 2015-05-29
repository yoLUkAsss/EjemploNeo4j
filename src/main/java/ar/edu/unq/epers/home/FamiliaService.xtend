package ar.edu.unq.epers.home

import ar.edu.unq.epers.model.Persona
import org.neo4j.graphdb.GraphDatabaseService

class FamiliaService {

	def home(GraphDatabaseService graph) {
		new FamiliaHome(graph)
	}

	def eliminarNodo(Persona persona) {
		Neo4JService.run[home(it).eliminarNodo(persona); null]
	}

	def getNodo(Persona persona) {
		Neo4JService.run[home(it).getNodo(persona)]
	}

	def crearNodo(Persona persona) {
		Neo4JService.run[home(it).crearNodo(persona); null]
	}

	def padreDe(Persona padre, Persona hijo) {
		Neo4JService.run[home(it).padreDe(padre, hijo)]
	}

	def hermanos(Persona hermano1, Persona hermano2) {
		Neo4JService.run[home(it).hermanos(hermano1, hermano2)]
	}

	def primosDe(Persona persona) {
		Neo4JService.run[home(it).primosDe(persona)]
	}

	def pradres(Persona persona) {
		Neo4JService.run[
			val home = home(it)
			home.padres(persona).map[home.crearPersona(it)].toList
		]
	}
}