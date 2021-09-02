# Пишем хэлм-чарт :smiley:

## Переменные из файла **Chart.yaml**:
```yaml
"{{ .Chart.Name }}-{{ .Release.Name }}"
```
Подставить релиз нейм при локальном рендере темплейта:
```bash
helm template . --name-template myRelease!
```
## Дефолтные значения переменных
Данный прием выручит, если кто-то забыл (случайно удалели) указать значение переменной в  values.yaml
```yaml
spec:
  replicas: {{ .Values.replicas | default 2 }}
```
## Подмена значение переменной в файле **values.yaml**
Переменная переопределяемое из-под cli имеет больший приоритет, чем переменная в файле `values.yaml`, таким образом она попадет в финальный рендер.
```bash
helm template . --set image.tag=1.21
```
## Подстановка целого блока в k8s манифест
Можно определить в манифесте только блок, а описать его уже в `values.yaml`

`./templates/simple-deployment.yaml`
```yaml
...
      resources:
{{ toYaml .Values.resources | indent 8 }}
...
```
`./values.yaml`
```yaml
resources:
  limits:
    cpu: 100m
    memory: 128Mi
  request:
    cpu: 80m
    memory: 64Mi
```
В данном случае, функция `indent` указывает на какое количество пробелов должен быть сдвиг первого элемента словаря (в нашем случае первый элемент это `resources:`).

## Добавление блока в манифест k8s по условию
```yaml
{{ if .Values.annotations }}
  annotations:
{{ toYaml .Values.annotations | indent 4 }}
{{ end }}
```
Но рендер будет выглядеть вот так:
```bash
metadata:
  name: "myapp-foo"
  labels:
    app:

  annotations:
    day: Monday
    spam: eggs

spec:
  replicas: 2
```
Решается с помощью `-` перед блоков flowcontrol:
```yaml
{{- if .Values.annotations }}
  annotations:
{{ toYaml .Values.annotations | indent 4 }}
{{- end }}
```
## Подключение переменных окружения с помощью **loop**
Формат env vars в манифестах k8s такой:
```yaml
      containers:
        - name: busybox
          ...
          env:
            - name: foo
              value: bar
            ...
```
`{{ $k/v | qoute }}` функция `qoute` - это умное заключение в кавычки, если их нет - подставит, если есть не обернет еще в одни.
```yaml
{{- if .Values.env }}
        env:
        {{- range $key, $val := .Values.env }}
          - name: {{ $key | quote }}
            value: {{ $val | quote }}
        {{- end }}
{{- end}}
```
## Как научиться клево теймплетировать?
Скачивать чарты из инета и изучать их :see_no_evil:
