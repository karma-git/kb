---
title: "Mkdocs, GitHub Pages, CloudFlare custom domain"
tags:
  - DoCops
comments: true
---

Что нужно сделать?

1. Иметь Domain и DNS zone на cloudflare, типа andrewhorbach.com
2. SSG (у меня MkDocs + MkDocs Material) + деплой в github pages
3. В DNS zone создаем записи [link](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site?platform=mac#dns-records-for-your-custom-domain). Везде выключить togle proxied, нужно чтобы он был выключен (unproxied) и облачко было серым
   1. A & AAAA с name @ (Apex Domain)
   2. wwww -> USERNAME.github.io, karma-git.github.io
4. SSL\TLS -> Overview -> Configure -> Full (Strict)

5. Теперь нужно переписывать domain pages для github репозитория. Есть некий способ с CNAME файликом, но сколько бы я не пробовал - у меня не получалось.
   1. Создаем GitHub [PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens), GitHub main page -> Settings -> Developer Settings -> PAT
   2. Добавляем в секреты репы: GitHub repo -> Settings -> Secrets and variables -> Actions: add GH_PAT
   3. В github action:

```yaml
      - run: echo "{{ github.repository }}"
      # ✅ Добавляем custom domain через GitHub API
      - name: Set GitHub Pages Custom Domain
        run: |
          curl -X PUT -H "Authorization: token ${{ secrets.GH_PAT }}" \
            -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/repos/${{ github.repository }}/pages \
            -d '{"cname": "andrewhorbach.com"}'
```

<!-- 
TODO:
- cloudflare via terraform
- github actions course!
- Ru + Eng

 -->

<!-- 
tmp: links

Profiles:
- https://brittanychiang.com/#projects
- https://www.adhamdannaway.com/about
- https://www.darianabok.ru/

GH pages docs:

- https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site
- https://docs.github.com/en/pages/getting-started-with-github-pages/securing-your-github-pages-site-with-https

Custom domain (cname field) overrides:
- https://github.com/orgs/community/discussions/22366
- https://github.com/orgs/community/discussions/48422
- https://github.com/alshedivat/al-folio/issues/130
- https://github.com/TanYuanXiangElroy/TanYuanXiangElroy.github.io/commit/cdcbc5f726c5b5f5098940b7bd209dfa854a3195
 -->