package ar.edu.unq.epers.service

import ar.edu.unq.epers.home.FamiliaHome
import ar.edu.unq.epers.model.Persona
import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.model.TipoDeRelaciones

class FamiliaService {

	private def createHome(GraphDatabaseService graph) {
		new FamiliaHome(graph)
	}

	def eliminarPersona(Persona persona) {
		GraphServiceRunner::run[
			createHome(it).eliminarNodo(persona)
			null
		]
	}

	def agregarPersona(Persona persona) {
		GraphServiceRunner::run[
			createHome(it).crearNodo(persona); 
			null
		]
	}

	def padreDe(Persona padre, Persona hijo) {
		GraphServiceRunner::run[
			val home = createHome(it);
			home.relacionar(padre, hijo, TipoDeRelaciones.PADRE)
			home.relacionar(hijo, padre, TipoDeRelaciones.HIJO)
		]
	}

	def hermanos(Persona hermano1, Persona hermano2) {
		GraphServiceRunner::run[
			val home = createHome(it);
			home.relacionar(hermano1, hermano2, TipoDeRelaciones.HERMANO)
			home.relacionar(hermano2, hermano1, TipoDeRelaciones.HERMANO)
		]
	}


	def primosDe(Persona persona) {
		GraphServiceRunner::run[
			val home = createHome(it);
			home.getPrimos(persona)
		]
	}

	def padres(Persona persona) {
		GraphServiceRunner::run[
			val home = createHome(it)
			home.getPadres(persona)
		]
	}
}