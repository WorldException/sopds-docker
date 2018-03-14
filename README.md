#### Simple OPDS Catalog - Простой OPDS Каталог
#### Author: Dmitry V.Shelepnev  Devops: Evgeniy Stoyanov

#### Введение

OPDS каталог для мобильных устройств.
Предоставляет удобный веб интерфейс для поиска и хранения книг.
Сайт разработчика https://github.com/mitshel/sopds

#### Установка

Для запуска требуется установить docker и docker-compose
Скачать файл и подправить docker-compose.yml
В двух местах надо указать путь к вашей библиотеке

    volumes:
      - "путь к папке с книгами:/books"

Запустить сервисы командой в папке с `docker-compose.yml` файлом

    docker-compose up -d

Зайти на http://localhost:8001/ по умолчанию пароль и пользователь `admin`
На этом установка завершена, проверить что все запущено можно командой

    docker-compose ps

#### Самостоятельная сборка

Если вам требуется собрать контейнер самостоятельно, то

    docker-compose build

