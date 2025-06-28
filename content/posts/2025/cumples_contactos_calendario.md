---
title: Cumpleaños de contactos a calendario
summary: Sincroniza los cumpleaños de tus contactos a un calendario. 100% local.
author: Appuchia
date: 2025-04-06
categories:
  - ES
  - Software
tags:
  - Afternoon project
---
Buenas de nuevo.

Hace unos días se me ocurrió que podía estar bien tener un script para sincronizar los cumpleaños, que guardo en mis contactos, a un calendario, para poder verlo en todos los dispositivos que necesite.

Y sí, sé que muchas aplicaciones de calendario lo hacen automáticamente, y que Nextcloud también lo incluye, pero mi entorno ahora mismo es Baïkal, Davx⁵ y Fossify Calendar.

Fossify Calendar me crea los eventos de cumpleaños pero he tenido problemas exportándolos y creando un calendario con ellos, y de todas formas era un trabajo manual, así que me hacía falta esto de todas formas.

El código está disponible [en mi gitea](https://git.appu.ltd/appu/birthday_cardtocal), y el nombre está en inglés porque no me apetecía ser ocurrente para evitar la `ñ` de cumpleaños.

## Requisitos

Como siempre, hay que establecer un margen en el que trabajar.

- Necesito que funcione con Baïkal, el servidor DAV que uso ahora mismo. [^1]
- Tiene que poder funcionar periódicamente sin dar problemas.
- Voy a usar Python porque ya me parece suficientemente tedioso tener que usar XML como para que aún encima sea en otro lenguaje.
- Idealmente en Docker, para que sea más cómodo y no tener que lidiar con el cron del sistema (*\*tose*).

## Qué he usado

Uso 2 librerías específicas, una para gestionar contactos y otra para conectarme y modificar calendarios.

La que gestiona los contactos es [vObject](https://github.com/skarim/vobject), muy cómoda para leer y crear vCards, tiene también soporte para calendarios pero terminé no usándolo.
La que lidia con los calendarios es [caldav](https://github.com/python-caldav/caldav). Permite conectarse directamente al servidor y comprobar y añadir los eventos.

Además de esas 2, uso `requests` para pedir los contactos (me costó entender cómo autenticarme al servidor...) y `lxml` como parser de XML (aunque probablemente la de la librería estándar funcionase igual de bien, no hago nada raro).

También uso `python-dotenv` para cargar las variables definidas en el archivo `.env` al entorno del script.

El `requirements.txt` tiene más paquetes porque es el autogenerado por Pipenv y guarda todas las versiones exactas que estaba usando, pero con instalar las 5 de arriba sirve.

## Cómo funciona

Cuando lo ejecutas (con todos los parámetros necesarios, luego entro en detalle), buscará todos los contactos de la libreta que le hayas dado, filtrará para quedarse con los que tengan un cumpleaños guardado y mostrará el número de cumpleaños a guardar.

A continuación se conectará al calendario que le indiques y obtendrá todos los eventos disponibles. \
Para cada contacto, comprobará si existe un evento con su nombre, y en caso de no existir lo creará. Si el evento existe y no coincide la fecha, modificará el evento a la nueva fecha almacenada en el contacto, y si coincide, simplemente lo ignorará y continuará.

Es un bucle sencillo pero en mis pruebas funciona, y lleva funcionando así como una semana.

### Docker

Para cumplir el otro requisito de arriba, había que meterlo en un contenedor, y para eso hay un Dockerfile sencillito en el repo que crea una imagen con Python 3.13 (el que cuadra que usé en ese momento) en Debian, le instala y configura cron, y le añade los `.py` de la carpeta.

Cuando se ejecuta simplemente llama a cron, que iniciará el script, y sigue `/opt/birthdays/cron.log`, donde se escribe toda la salida del programa.

Es de los primeros contenedores que hago así que igual no es buena práctica alguna de las cosas que he hecho pero la verdad lo único importante de esto era que funcionase cuanto antes.

## Disclaimers

El código no es demasiado bonito pero tampoco me he preocupado mucho por que lo sea.
Está escrito para que funcione y para que me fuese cómodo mientras lo montaba, no necesariamente para leerlo 2 semanas después, intentaré limpiarlo un poquillo antes de publicar el post, pero no prometo nada.

## Cómo usarlo

Como no me apetecía aprender a subir imágenes a registros de contenedores, te toca montarte la imagen a ti si la quieres usar.
No es muy complicado de todas formas.

1. Primero de todo, clona el repo:
```shell
git clone https://git.appu.ltd/appu/birthday_cardtocal
```

2. Cubre los detalles de `template.env` y renómbralo a `.env`.
- `CARD_URL`: Enlace a *la libreta de contactos específica* que vayas a usar.
- `CAL_URL`: Enlace al *calendario específico* en el que guardar los cumpleaños.
- `DAV_USER`: Nombre de usuario para ambos.
- `DAV_PASS`: Contraseña para ambos.

2. Modifica las líneas de `Dockerfile` que gestionan cron si quieres cambiar la frecuencia con la que se ejecuta.
	Por defecto está en 5 minutos aunque igual la cambio, así que revísala por si acaso, pondrá lo que mejor me venga a mi. \
	Si no te suena cron y quieres ver el formato que usar, [esta página](https://crontab.guru/) es buen recurso.

3. Revisa `compose.yaml` para asegurarte de que está todo como quieres. [^2]

4. Arranca el contenedor para comprobar que funciona.
   > Si no tienes `docker` y `docker-compose` instalado, asegúrate de hacerlo antes, o esto no te funcionará. Hay infinidad de guías por ahí que cuentan cómo hacerlo, no es el point de este post.

	```shell
	docker compose up
	```
	La salida debería ser algo similar a esto:
	![Salida de docker compose](/images/2025/cumples_contactos_calendario/docker-compose-log.png)
	Páralo cuando consideres con `CTRL+C`, aprovecha para asegurarte de que la frecuencia que pusiste es la que está usando.

5. Ejecútalo como servicio en segundo plano y olvídate.
	```shell
	docker compose up -d
	```

Si te da algún problema intentando montar algo de todo esto, tienes forma de contactarme entrando en [mi página principal](https://info.appu.ltd/?utm_source=blog&utm_medium=cumples_contactos_calendario).

## Conclusiones

Este es un post un poco más de guía, no tanto un "hice esto", más que nada porque es una idea sencilla pero que me pareció interesante poder implementar y que me es cómoda.

Te animo a ti que me lees a intentar hacer cosas así por estúpidas o complejas que te parezcan, investigar ideas que tienes y sacarlas adelante o fallar aporta mucho valor, y cuando funcionan tienes algo nuevo que usar \
Aunque no sea relacionado con la informática o los ordenadores, investiga e intenta sacar cosillas adelante :)

---

Gracias por leerme!

Hecho con 🖤 por Appu.

[^1]: Tengo pendiente escribir algo sobre ello, de momento sirve con saber que es un estándar para servir archivos, aunque también se usa para servir contactos y calendarios por encima, que es lo que implementa Baïkal (y estoy bastante contento). Para más info, [Wikipedia](https://en.wikipedia.org/wiki/WebDAV).

[^2]: Me acabo de dar cuenta mientras escribo esto de que el compose está bastante feo por el apartado de `watch` y que diría que es redundante definir las variables de entorno en el compose si aún así le monto el `.env`, pero bueno, ya veré si lo limpio.
