---
title: Mis dotfiles
summary: Publicando mis dotfiles
author: Appuchia
date: 2025-02-28
lastmod: 2025-04-23
categories:
  - ES
  - Linux
tags:
  - Configuration
  - Stow
---
> Post actualizado a 2025-04-23 con el enlace al post de stow.

## Hago públicos mis "dotfiles"

Puede que no te sorprenda, en el fondo ya llevo tiempo teniéndolos públicos,
pero hace un par de meses cambié mi forma de lidiar con ellos y estoy contento
con cómo están quedando, así que ahora estarán públicos por si quieres inspirarte
(guiño guiño).

## Qué vienen siendo los dotfiles?

Pregunta sin miedo!

En resumidas cuentas, son los archivos de configuración que se usan en Linux[^1].

Se les llama así porque van precedidos por un punto, que se interpreta como
que son archivos ocultos.
Es cómodo, porque un usuario casual del sistema no los verá y no le molestan,
pero son fáciles de modificar y están a mano para quien sí quiera usarlos.

Son geniales porque estandarizan la configuración y las rutas donde guardarla,
entonces es fácil compartir los ajustes que tengas en una aplicación o utilidad,
y también es fácil migrar y sincronizar esas configuraciones entre distintos
ordenadores.

## Qué ha cambiado

Las versiones anteriores de estos archivos siguen disponibles en [mi GitLab](https://gitlab.com/appuchia-dotfiles),
pero son repositorios distintos para cada proyecto y era más tedioso de adoptar
y de mantener.

Desde que descubrí `stow`, una herramienta de GNU, los estuve migrando poco a poco
viendo qué tal funcionaba, y la verdad es que estoy bastante contento. \
Te deja centralizar los dotfiles y da pocos dolores de cabeza.

Funciona "al revés" de mi idea inicial para juntarlos.
Yo pensaba usar los "hard links" disponibles en Linux y ext4 para que los archivos
que usa cada programa en su carpeta[^2] de configuración se "sincronizasen" con otros
en una carpeta en la que crear el repositorio global. \
Pero esto tiene la pega de que cuando lo clone en un nuevo PC tengo un rato de trabajo
manual de volver a hacer todos los links a cada ruta concreta.
Y aún peor, no puedes hacer enlaces de carpetas, así que tendría que ir archivo a
archivo y no es plan, la verdad.

## Stow

Stow facilita esto porque se encarga él solito de gestionar los enlaces.

Tienes un par de comandos para gestionar los enlaces de la carpeta de dotfiles
que uses y listo. \
Lo que me causa dudas es que stow trabaja con enlaces simbólicos en vez de
"hard links". La diferencia es que el enlace simbólico no es "una copia" del
archivo de origen, sino que solo almacena la ruta al archivo del que es enlace.
Tiene la ventaja de que es un archivo minúsculo y funciona con carpetas, pero
no estoy seguro de que todos los programas vayan a lidiar bien con eso, aunque
de momento no he tenido ningún problema, para ser sincero.

Uso 2 comandos de stow, que tengo automatizados con 2 scripts para ahorrarme
trabajo y gestionar variables de entorno y eso bien:

- Para crear los enlaces simbólicos apuntando a la carpeta de dotfiles: \
  `stow -v --dotfiles -t ~ -R . $@`
- Para eliminar todos los enlaces simbólicos: \
  `stow -v -D ~/.dotfiles`

Los tengo guardados como `stow_reload` y `stow_delete` (están en el repo).

Cuando añado algún archivo nuevo a la carpeta de dotfiles, con ejecutar el primero
se crea la carpeta necesaria en la ruta que pongas y listo. \
Y si alguna vez quisiera eliminarlos todos, con el segundo es rápido.

Uso un par de flags en los comandos que igual resultan útiles.

- Con `-v` stow muestra qué cambios está haciendo.
- Con `--dotfiles` convierte los nombres de `dot-*` a `.*`.
- `-t` establece la ruta base en la que crear los enlaces.
- `-R` regenera los enlaces.
- `-D` elimina los enlaces.

De todas formas, si lo vas a usar busca más info por ahí o léete `man stow`.

Tengo intención de escribir otro post entrando más en detalle en cómo usar stow y
mi "workflow" con estas cosas, pero de momento solo está este. \
Cuando lo publique estará aquí ↴

El post con mi uso de stow:
https://blog.appu.ltd/posts/2025/stow/

## Conclusiones

Este post era una forma de dejar este cambio por escrito más que nada.

Y bueno, que me acabo de dar cuenta de que no lo puse, los dotfiles están
en [mi Gitea](https://git.appu.ltd/appu/dotfiles). \
Según publique esto me pondré a hacer un readme algo más detallado de cómo empezar
a usarlos, un detallito sin importancia.

Espero que te sea de alguna utilidad y te anime a hacer algo con tus dotfiles! \
Cualquier cosa que te apetezca es buen proyecto :)

Para hablar más de esto, tienes info sobre mí y cómo contactarme en [info.appu.ltd](https://info.appu.ltd/?utm_source=blog&utm_medium=dotfiles).

---

Gracias por leerme!

Hecho con 🖤 por Appu.

[^1]: Realmente no es exclusivo de linux, pero es donde los uso yo, así que eso.
[^2]: Sí, sé que se llaman "directorios", pero carpeta es más breve y lo importante de la comunicación es entenderse, y sabes a qué me refiero.
