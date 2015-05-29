package ar.edu.unq.epers.service

import ar.edu.unq.epers.home.FamiliaService
import ar.edu.unq.epers.model.Persona
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class FamiliaServiceTest {
	Persona padre
	Persona tio
	Persona hijo
	Persona primo
	Persona primo2
	FamiliaService service
	
	
	@Test
	def void esPadre(){
		val padres = service.pradres(hijo)
		Assert.assertEquals(1, padres.length)
		Assert.assertEquals(padres.head, padre)
	}
	
	@Test
	def void sonPrimos(){
		val primos = service.primosDe(hijo)
		
		Assert.assertEquals(2, primos.length)
		Assert.assertTrue(primos.contains(primo))
		Assert.assertTrue(primos.contains(primo2))
	}
	
	@After
	def void after(){
		service.eliminarNodo(padre)
		service.eliminarNodo(tio)
		service.eliminarNodo(hijo)
		service.eliminarNodo(primo)
		service.eliminarNodo(primo2)
	}
	
	
	@Before
	def void setup(){
		padre = new Persona => [
			dni = "1111" 
			nombre = "Padre"
			apellido = "Pérez"
		];
		
		tio = new Persona => [
			dni = "2222" 
			nombre = "Tio"
			apellido = "Pérez"
		];
		
		hijo = new Persona => [
			dni = "3333" 
			nombre = "Hijo"
			apellido = "Pérez"
		];
		
		primo = new Persona => [
			dni = "4444" 
			nombre = "Primo"
			apellido = "Pérez"
		];
		
		primo2 = new Persona => [
			dni = "5555" 
			nombre = "Primo2"
			apellido = "Pérez"
		];
		
		service = new FamiliaService
		service.crearNodo(padre)
		service.crearNodo(tio)
		service.crearNodo(hijo)
		service.crearNodo(primo)
		service.crearNodo(primo2)
		service.padreDe(padre, hijo)
		service.padreDe(tio, primo)
		service.padreDe(tio, primo2)
		service.hermanos(padre, tio)
		service.hermanos(primo, primo2)
		
	}
}