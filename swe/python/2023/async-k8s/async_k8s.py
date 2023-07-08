import asyncio
from kubernetes_asyncio import client, config
from kubernetes_asyncio.client.api_client import ApiClient

import typing as t

class k8sAsyncTask:
    def __init__(self, contexts: list, task: t.Callable):
        self._ctxs = contexts
        self._task = task

    async def _task_runner(self, ctx):
        try:
            # Загрузка конфигурации кластера
            await config.load_kube_config(context=ctx)

            # use the context manager to close http sessions automatically
            async with ApiClient() as api:
                result = await self._task(api)
                return ctx, result

        except Exception as e:
            # Обработка ошибок, если необходимо
            print(f"Error in cluster {ctx}: {str(e)}")
            return ctx, None

    async def tasks_results(self):
        tasks = []

        for ctx in self._ctxs:
            task = asyncio.create_task(self._task_runner(ctx))
            tasks.append(task)

        # Ожидание завершения всех задач
        completed_tasks = await asyncio.gather(*tasks)
        # Преобразуем списки с результатами в словари
        zipped = dict(zip(self._ctxs, completed_tasks))
        result = { k: zipped[k][1] for k in zipped}

        return result
