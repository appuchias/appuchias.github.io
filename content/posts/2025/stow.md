---
title: Gestionando dotfiles con stow
description: Cómo usar stow para gestionar tus dotfiles u otros enlaces
author: Appuchia
date: 2025-04-23
categories:
  - ES
  - Linux
  - Software
tags:
  - Utility
  - Learning
  - Stow
---

Aquí está el prometido post sobre `stow`!

Contaré el uso práctico del programa para el uso que le doy yo, hablando desde mi experiencia.

# Qué es?

> Eres libre de saltar esto, seré breve

Stow es una herramienta de GNU, pensada para la gestión de archivos de configuración de utilidades, pero que en realidad se puede usar en cualquier otro contexto que requiera gestionar enlaces simbólicos a archivos en distintas rutas que quieras sincronizar a un solo directorio.

# Instalación

Si usas algo que no sea Linux vas a tener que buscarte la vida.

Si usas una distribución de linux habitual, lo más probable es que stow esté en los repositorios de la distribución, entonces la instalación será igual que para cualquier otro programa.

Por ejemplo, en Arch Linux y derivados:
```shell
sudo pacman -S stow
```
O en Debian y derivados:
```shell
sudo apt install stow
```

# Uso básico

La forma de operar de stow es quizá al revés de como la imaginas.

Stow opera desde un directorio que contiene los "originales" de los archivos de configuración.
La estructura de archivos dentro de este directorio será la que use para crear los enlaces simbólicos.

Para los ejemplos usaré esta estructura de archivos
```txt
/home/appu/stow
├─ dir1
│  ├─ file1.txt
│  └─ file2.png
├─ dir2
│  ├─ dir3
│  │  └─ file3.sh
│  └─ file4.md
└─ file5.conf
```

> Puedes recrearla ejecutando lo siguiente desde la raíz de tu usuario:
> ```shell
> mkdir stow && cd stow
> mkdir -p dir{1,2/dir3}
> touch dir1/{file1.txt,file2.png} dir2/file4.md dir2/dir3/file3.sh file5.conf
> ```

Si la quisieses aplicar sobre `/home/appu/projects`, desde `/home/appu/stow` ejecutarías lo siguiente
```shell
stow -t ~/projects -S .
```

- `-t` indica la ruta destino raíz a partir de la cual crear los enlaces.
- `-S` indica que quieres "stowear" el paquete (la ruta) a continuación.
- `.` indica la ruta actual.

Y stow crearía los siguientes enlaces:
```txt
/home/appu/projects/dir1/ -> ../stow/dir1
/home/appu/projects/dir2/ -> ../stow/dir2
/home/appu/projects/file5.conf -> ../stow/file5.conf
```

Pero si se da el caso de que `dir2` existe ya en `projects` y contiene un archivo que stow no incluye en la estructura del paquete que le indicas, crearía los siguientes enlaces:
```txt
/home/appu/projects/dir1/ -> ../stow/dir1
/home/appu/projects/dir2/dir3 -> ../stow/dir2/dir3
/home/appu/projects/dir2/file4.md -> ../stow/dir2/file4.md
/home/appu/projects/file5.conf -> ../stow/file5.conf
```
Y de esta forma respetaría los archivos ya existentes, pero crearía todos los enlaces necesarios.

# Más funcionalidad

## Si te cansas

Si quieres dejar de usar stow o simplemente necesitas eliminar los enlaces por cualquier otro motivo, puedes usar la opción `-D` antes de indicar la ruta en lugar de `-S`. Desde `/home/appu/stow`:
```shell
stow -v -t ~/projects -D .
```
Daría la salida
```txt
UNLINK: dir1
UNLINK: dir2
UNLINK: file5.conf
```

## Ruta de stow

Puedes ejecutar stow desde cualquier otra ruta indicando con el parámetro `-d`la ruta base desde donde ejecutar stow.
Por ejemplo, para crear los enlaces pero desde `/home/appu`, podrías ejecutar
```shell
stow -d ~/stow -t ~/projects -S .
```

Si te sorprende que hasta ahora el comando no haya devuelto ninguna salida, es porque no se le ha pedido, con `-v` mostrará los enlaces creados y eliminados.
Por ejemplo:
```txt /home/appu/stow
❯ stow -v -t ~/projects -S .
LINK: dir1 => ../stow/dir1
LINK: dir2 => ../stow/dir2
LINK: file5.conf => ../stow/file5.conf
```

## Dotfiles

Existe también la opción `--dotfiles`, pensada específicamente para el uso con dotfiles evidentemente, esta opción interpreta los nombres que empiecen por `dot-` como si empezasen por punto.
Personalmente uso la opción porque tiene la ventaja de que todos los archivos dentro de la carpeta de dotfiles son visibles sin activar nada especial, pero tiene la pega de que es más lento de escribir cuando quieres acceder a una ruta específica, al tener que escribir ese prefijo siempre. \
Tienes un ejemplo entrando en [mi repo de dotfiles tal como está ahora](https://git.appu.ltd/appu/dotfiles/src/commit/c0b465f159f5876f6cb21c6afc3e1dd1ef4999ad) y viendo cómo se llaman los archivos.

## Recrear enlaces

Si quieres recrear todos los enlaces, bien porque has eliminado archivos extra de stow, bien por vicio, puedes hacerlo con la opción `-R` en el mismo lugar que `-S`.
```shell
stow -t ~/projects -R .
```
Haría lo mismo en la primera ejecución que el ejemplo de arriba, pero en consecutivas ejecuciones eliminaría todos los enlaces antes de crearlos de nuevo.

Esto es útil porque de esta forma creará enlaces que serán el mínimo número posible, y puede ser más cómodo, de hecho es lo que hace mi scriptcillo `stow_reload`.

## Stow ignore

Si quieres usar stow para tener tus dotfiles en un repositorio, te interesará que ignore cosas como `.git`, `README.md`, `LICENSE` y otras del estilo.

Puedes incluir un archivo `.stow-local-ignore` en la raíz de tu carpeta de stow en el que indicar los patrones que debe ignorar.
Tienes un archivo de ejemplo [aquí](https://www.gnu.org/software/stow/manual/html_node/Types-And-Syntax-Of-Ignore-Lists.html) o usando `info stow` en la sección 4.2.
Lo más probable es que tenga todo lo que necesites, pero puedes añadit cuanto quieras, en ambos recursos tienes la documentación para la sintaxis que usar.

## Otras opciones

Como medida de precaución, siempre puedes añadir `-n` al final del comando para ver qué va a hacer antes de ejecutarlo de verdad.
`-n` simulará la ejecución sin afectar a tus archivos.

Puedes usar también la opción `--adopt` para incluir los archivos que ya existan en la ruta destino en tu carpeta de stow.
No suele ser lo que quieres, pero puede resultar cómodo si estás añadiendo archivos nuevos de configuración, aunque no lo uso personalmente.

Hay más opciones pero no las uso, así que tampoco puedo hablar mucho de ellas.
Con `stow --help`, `man stow` o `info stow` (ordenadas de menos a más completas) puedes ver de forma más detallada todas las posibilidades.

# Conclusiones

Stow es una herramienta muy cómoda para gestionar los dotfiles, y de momento no he tenido mucho problema con ella desde que entendí cómo se usaba.

Si tienes margen y te apetece lo recomiendo combinado con git para un buen control de versiones, pudiendo ver cómo tenías algo configurado en cualquier momento del tiempo, y con el respaldo de tener tus configuraciones a salvo en un repositorio (no necesariamente público, ten cuidado con lo que subes!).

Como siempre, si se te complica puedes contactarme por donde prefieras, tienes enlaces en [info.appu.ltd](https://info.appu.ltd/?utm_source=blog&utm_medium=stow).

P.D.: Al terminar de escribir el post encontré este otro por ahí y tiene buena pinta, por si también le quieres echar un ojo: https://tamerlan.dev/how-i-manage-my-dotfiles-using-gnu-stow/

---

Gracias por leerme!

Hecho con 🖤 por Appu.
