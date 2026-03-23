# video-to-fbx (ComfyUI + RunPod worker)

Docker-образ разворачивает ComfyUI с workflow, который конвертирует видео в FBX.

Основной workflow: `video_to_fbx_api_final.json`.

## Что внутри

- Образ поднимает ComfyUI и использует модули/ноды, указанные в `Dockerfile`.
- Для корректной работы требуется дополнительный патч модулей/нод (после установки).
- Внутри контейнера используется каталог `runpod-volume` под volume RunPod, где лежат модели, входы и выходы.

## Готовый Docker-образ

- Docker Hub: `michaellevinx/comfy-fbx`
- Размер образа: ~15.9 GB
- Ссылка: https://hub.docker.com/r/michaellevinx/comfy-fbx

Можно использовать два варианта:

1. Сборка из `Dockerfile` + архива в этом проекте.
2. Использование уже собранного образа из Docker Hub.

## Запуск

### RunPod worker (основной сценарий)

```bash
python3 /comfyui/main.py --listen 0.0.0.0
```

### Обычный запуск ComfyUI

Используется та же команда:

```bash
python3 /comfyui/main.py --listen 0.0.0.0
```

## Пути внутри контейнера

- Модели: `/runpod-volume/models`
- Входные данные: `/runpod-volume/input`
- Результаты: `/runpod-volume/output`

Достаточно примонтировать любую папку хоста в контейнер как `/runpod-volume/`.

## Workflow

- Файл workflow: `video_to_fbx_api_final.json`

## Разница между workflow-файлами

В проекте есть два JSON-файла с похожей логикой, но разным назначением:

- `video_to_fbx_api_final.json` — UI-экспорт из ComfyUI (редакторный формат):
  - содержит `nodes`, `links`, `groups`, позиции нод и служебные метаданные;
  - удобен для редактирования и отладки workflow в интерфейсе ComfyUI;
  - в текущем варианте использует `VHS_LoadVideo` (обычная загрузка видео в UI).

- `sam_fbx_runpod.json` — API/runtime-формат для RunPod:
  - упакован в структуру `input.workflow` с `class_type` и `inputs`;
  - ориентирован на запуск в воркере и контейнерных путях;
  - использует `VHS_LoadVideoPath` с путями вида `/runpod-volume/input/...`.

Практически:

- для разработки/правок в ComfyUI: `video_to_fbx_api_final.json`;
- для продакшн-запуска в RunPod worker: `sam_fbx_runpod.json`.
