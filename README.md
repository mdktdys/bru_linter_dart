Этот репозиторий содержит дополнительные правила для `custom_lint`:

*   **missing\_type**: проверяет наличие явного типа у переменных.
*   **missing\_comma**: подсказывает места для запятой в многострочных списках и аргументах.

Установка
---------

В `pubspec.yaml` вашего проекта добавьте зависимость:

    dev_dependencies:
      custom_lint:
      my_linter:
        git:
            url: my-url
    

В `analysis_options.yaml` добавьте плагин:

    
      analyzer:
        plugins:
            - custom_lint
      

После этого запустите:

    dart pub clean

    dart pub get

И перезапустите анализатор CMD + P (VS Code)

    Dart: Restart Analysis Server

Правило `missing_type`
----------------------

Правило проверяет, что все объявления переменных используют явный тип вместо `var` или `final` без указания типа.

### Bad:

    var count = 5;
    final name = 'Alice';

### Good:

    int count = 5;
    final String name = 'Alice';

* * *

Правило `missing_comma`
-----------------------

Правило подсказывает, где в многострочных литералах списков и аргументных списках можно поставить завершающую запятую. Исключаются случаи с именованными параметрами-литералами карт/множеств, замыканиями, вызовами методов и созданием экземпляров.

### Bad (список):

    final items = [
      'a',
      'b'
    ];

### Good (список):

    final items = [
      'a',
      'b',
    ];

### Bad (аргументы функции):

    fetchData(
      url,
      headers: {
        'Auth': token,
      }
    );

### Good (аргументы функции):

    fetchData(
      url,
      headers: {
        'Auth': token,
      },
    );
