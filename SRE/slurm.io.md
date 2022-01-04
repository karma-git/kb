# Overview

Серий вебинаров от slurm.io по SRE

## [Путь в SRE, вебинар курса «SRE: внедряем DevOps от Google»](https://www.youtube.com/watch?v=Cj9yKoF6hd0)
## [Особенности SRE в России, вебинар курса «SRE: внедряем DevOps от Google»](https://www.youtube.com/watch?v=VhArKrrT0Ww)
## [Определяем SLO и SLI для своего проекта, вебинар курса «SRE: внедряем DevOps от Google»](https://www.youtube.com/watch?v=6QkVlCIeJkM)

### Intro

- Чтo Taкoe SRE?
- Как спикер понимает термин SRE?
- DevOps vs SRE
- SRE: культура, техника, организация

<details>

### Чтo Taкoe SRE?

> Site Reliability Engineering is a discipline that incorporates aspects of
software engineering and applies them to infrastructure and operations problems.
>
> https://en.wikipedia.org/wiki/Site_Reliability_Engineering


> SRE’s approach to this is to apply a software engineering mindset to
system administration topics
>
> https://www.scalyr.com/blog/what-is-sre/

> ... what happens when you ask a software engineer to design an
operations function.
> 
> Ben Treynor, founder of Google's Site Reliability Team

---

### Как спикер понимает термин SRE?

* SRE - дисциплина, которая помогает вместе думать об одной
цели - как сделать Taк, чтобы наш продукт приносил пользу
клиентам

* SRE - владельцы надежности системы

---

### DevOps vs SRE

|DevOps                                                  |SRE                         |
|--------------------------------------------------------|----------------------------|
|DevOps говорит, куда нужно двигаться, но не говорит как | отвечает на вопрос частично|
|monitoring/alerting                                     |observability               |
|CI/CD automation                                        |CI/CD automation            |
|build/release/test automation                           |incident management         |
|packaging                                               |capacity planning           |
|IaaC                                                    |reliable system design      |
|infra management                                        |scalability                 |
|version control                                         |chaos engineering           |
|...                                                     |automation                  |

### SRE: культура, техника, организация

|культура                       |техника                 |организация           |
|-------------------------------|------------------------|----------------------|
|совладение                     |ops                     |mindset shift         |
|постоянное измерение результата|мониторинг/алертинг     |работа no алгоритму   |
|инкрементальные изменения      |практики надежных систем|смешанные команды     |
|blame-less культура            |chaos engineering       |TL/PO отвечает за Ops |
|автоматизация                  |                        |распространение знаний|

</details>
