object intensidadElevada {
  var property valor = 50
}

class Grupo {
  const property personas = []
  
  method vivirEvento(evento) = personas.forEach({ p => p.vivirEvento(evento) })
}

class Persona {
  var property edad
  const property emociones = []
  
  method esAdolescente() = edad.between(12, 19)
  
  method nuevaEmocion(emocion) = emociones.add(emocion)
  
  method porExplotar() = emociones.all({ e => e.puedeLiberarse() })
  
  method vivirEvento(evento) = emociones.forEach({ e => e.liberarse(evento) })
}

class Evento {
  const property impacto
  const property descripcion
}

class Emocion {
  var cantEventos = 0
  var property intensidad = 0
  
  method puedeLiberarse() = (intensidad > intensidadElevada.valor()) and self.condEspecifica()
  
  method condEspecifica()
  
  method liberarse(evento) {
    if (self.puedeLiberarse()) {
      cantEventos += 1
      self.intensidad(self.intensidad()-evento.impacto())
      self.accionEspecifica(evento)
    }
  }
  
  method accionEspecifica(evento) {}
}

class Furia inherits Emocion (intensidad = 100) {
  const palabrotas = []
  
  override method condEspecifica() = palabrotas.any({ p => p.size() > 7 })
  
  override method accionEspecifica(evento) {
    palabrotas.remove(palabrotas.first())
  }
}

class Alegria inherits Emocion {
  override method intensidad(nueva) {
    super(nueva.abs())
  }
  
  override method condEspecifica() = cantEventos.even()
}

class Tristeza inherits Emocion {
  var property causa = "melancolia"
  
  override method condEspecifica() = causa != "melancolia"
  
  override method accionEspecifica(evento) {
    causa = evento.descripcion()
  }
}

class Desagrado inherits Emocion {
  override method condEspecifica() = cantEventos > intensidad
}

class Temor inherits Emocion {
  override method condEspecifica() = cantEventos > intensidad
}

class Ansiedad inherits Temor {
  /*
  Lo que tiene de diferente la ansiedad es que se le puede especificar
  cierto nivel de ansiedad al liberarse (polimorfismo), en el cual se 
  libera la emocion del evento la cantidad de veces que se especifica.

  La condicion extra para liberarse es la misma que la de temor (herencia).
  La emocion es parecida a esta ultima pero subida de nivel, por lo que me
  parecio que las condiciones tienen que ser las mismas.
  */
  method liberarse(evento, nivel) {
    nivel.times({ self.liberarse(evento) })
  }
}