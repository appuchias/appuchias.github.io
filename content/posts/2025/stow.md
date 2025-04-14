---
title: Gestionando dotfiles con stow
description: ""
author: Appuchia
date: 2025-04-14
categories:
  - ES
tags: []
draft: true
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

# Uso

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

## Gestión de enlaces

Por ejemplo, para la siguiente estructura en el directorio de stow:
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

Si la recreases en `/home/appu/projects`, crearía los siguientes enlaces:
```txt
/home/appu/projects/dir1/ -> ../stow/dir1
/home/appu/projects/dir2/ -> ../stow/dir2
/home/appu/projects/file5.conf -> ../stow/file5.conf
```

Pero si se da el caso de que `dir2` existe ya en `projects` y contiene un archivo que stow no conoce, crearía los siguientes enlaces:
```txt
/home/appu/projects/dir1/ -> ../stow/dir1
/home/appu/projects/dir2/dir3 -> ../stow/dir2/dir3
/home/appu/projects/dir2/file4.md -> ../stow/dir2/file4.md
/home/appu/projects/file5.conf -> ../stow/file5.conf
```
Y de esta forma respetaría los archivos ya existentes, pero crearía todos los enlaces necesarios.

---

Gracias por leerme!

Hecho con 🖤 por Appu.
