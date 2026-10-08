#!/bin/bash

DATA_DIR="data"
DATA_FILE="$DATA_DIR/tasks.txt"

init_storage() {
    mkdir -p "$DATA_DIR"
    touch "$DATA_FILE"
}


show_header() {
    clear
    echo "================================"
    echo "        TASK MANAGER"
    echo "================================"
    echo
}

pause() {
    echo
    printf "Нажмите Enter, чтобы продолжить..."
    read _
}

show_menu() {
    echo "1. Добавить задачу"
    echo "2. Показать задачи"
    echo "3. Найти задачу"
    echo "4. Посчитать задачи"
    echo "5. Удалить задачу"
    echo "0. Выход"
    echo
}

add_task() {
    show_header

    printf "Введите задачу: "
    read TASK

    if [ -z "$TASK" ]; then
        echo "Пустую задачу добавить нельзя."
        return
    fi

    echo "$TASK" >> "$DATA_FILE"

    echo
    echo "Задача добавлена!"
}

list_tasks() {
    show_header

    if [ ! -s "$DATA_FILE" ]; then
        echo "Задач пока нет."
    else
        nl -ba "$DATA_FILE"
    fi
}

search_tasks() {
    show_header

    printf "Введите текст для поиска: "
    read QUERY

    if [ -z "$QUERY" ]; then
        echo "Поисковый запрос пустой."
        return
    fi

    echo
    grep -i "$QUERY" "$DATA_FILE" || echo "Ничего не найдено."
}

count_tasks() {
    show_header

    COUNT="$(wc -l < "$DATA_FILE")"

    echo "Количество задач: $COUNT"
}

delete_task() {
    show_header

    if [ ! -s "$DATA_FILE" ]; then
        echo "Задач пока нет."
        return
    fi

    nl -ba "$DATA_FILE"

    echo
    printf "Введите номер задачи для удаления: "
    read NUMBER

    if ! [[ "$NUMBER" =~ ^[0-9]+$ ]]; then
        echo "Нужно ввести число."
        return
    fi

    if [ "$NUMBER" -lt 1 ] || [ "$NUMBER" -gt "$(wc -l < "$DATA_FILE")" ]; then
        echo "Такой задачи нет."
        return
    fi

    sed -i "${NUMBER}d" "$DATA_FILE"

    echo "Задача удалена."
}

while true; do
    show_header
    show_menu

    printf "Выбор: "
    read CHOICE

    case "$CHOICE" in
        1)
            add_task
            pause
            ;;
        2)
            list_tasks
            pause
            ;;
        3)
            search_tasks
            pause
            ;;
        4)
            count_tasks
            pause
            ;;
        5)
            delete_task
            pause
            ;;
        0)
            echo "Выход из программы"
            break
            ;;
        *)
            echo "Ошибка: такого пункта нет"
            pause
            ;;
    esac
done
