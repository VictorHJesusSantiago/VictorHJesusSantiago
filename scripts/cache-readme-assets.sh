#!/usr/bin/env bash
# Downloads the dynamically-rendered SVGs/badges used in the profile READMEs and
# stores static copies under assets/readme/. The READMEs reference these local
# copies instead of the live third-party endpoints, so a slow/asleep/down service
# only ever results in a slightly stale image — never a broken one.
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p assets/readme

# name|url  (one per line)
ASSETS=$(cat <<'EOF'
banner-header-en.svg|https://capsule-render.vercel.app/api?type=waving&color=D4AF37,1a1a2e,D4AF37&height=180&section=header&text=Victor%20H.%20J.%20Santiago&fontSize=42&fontColor=ffffff&fontAlignY=38&desc=FullStack%20Developer%20%7C%20Soli%20Deo%20Gloria%20%E2%9C%9D%EF%B8%8F&descAlignY=60&descSize=18&animation=fadeIn
banner-header-pt.svg|https://capsule-render.vercel.app/api?type=waving&color=D4AF37,1a1a2e,D4AF37&height=180&section=header&text=Victor%20H.%20J.%20Santiago&fontSize=42&fontColor=ffffff&fontAlignY=38&desc=Desenvolvedor%20FullStack%20%7C%20Soli%20Deo%20Gloria%20%E2%9C%9D%EF%B8%8F&descAlignY=60&descSize=18&animation=fadeIn
banner-header-es.svg|https://capsule-render.vercel.app/api?type=waving&color=D4AF37,1a1a2e,D4AF37&height=180&section=header&text=Victor%20H.%20J.%20Santiago&fontSize=42&fontColor=ffffff&fontAlignY=38&desc=Desarrollador%20FullStack%20%7C%20Soli%20Deo%20Gloria%20%E2%9C%9D%EF%B8%8F&descAlignY=60&descSize=18&animation=fadeIn
banner-footer.svg|https://capsule-render.vercel.app/api?type=waving&color=1a1a2e,D4AF37&height=120&section=footer&animation=fadeIn
stats.svg|https://github-readme-stats.vercel.app/api?username=VictorHJesusSantiago&show_icons=true&theme=monokai&title_color=D4AF37&icon_color=D4AF37&border_color=D4AF37&hide_border=false&count_private=true
top-langs.svg|https://github-readme-stats.vercel.app/api/top-langs/?username=VictorHJesusSantiago&layout=compact&theme=monokai&title_color=D4AF37&border_color=D4AF37&hide_border=false&langs_count=8
profile-details.svg|https://github-profile-summary-cards.vercel.app/api/cards/profile-details?username=VictorHJesusSantiago&theme=tokyonight
most-commit-lang.svg|https://github-profile-summary-cards.vercel.app/api/cards/most-commit-language?username=VictorHJesusSantiago&theme=tokyonight
repos-per-lang.svg|https://github-profile-summary-cards.vercel.app/api/cards/repos-per-language?username=VictorHJesusSantiago&theme=tokyonight
stats-summary.svg|https://github-profile-summary-cards.vercel.app/api/cards/stats?username=VictorHJesusSantiago&theme=tokyonight
activity-graph-en.svg|https://github-readme-activity-graph.vercel.app/graph?username=VictorHJesusSantiago&bg_color=1a1a2e&color=D4AF37&line=D4AF37&point=ffffff&area=true&hide_border=true&custom_title=Contribution%20History
activity-graph-pt.svg|https://github-readme-activity-graph.vercel.app/graph?username=VictorHJesusSantiago&bg_color=1a1a2e&color=D4AF37&line=D4AF37&point=ffffff&area=true&hide_border=true&custom_title=Hist%C3%B3rico%20de%20Contribui%C3%A7%C3%A3o
activity-graph-es.svg|https://github-readme-activity-graph.vercel.app/graph?username=VictorHJesusSantiago&bg_color=1a1a2e&color=D4AF37&line=D4AF37&point=ffffff&area=true&hide_border=true&custom_title=Historial%20de%20Contribuciones
typing-en.svg|https://readme-typing-svg.herokuapp.com/?color=D4AF37&size=28&center=true&width=600&lines=Hi+there%2C+I%27m+Victor+%F0%9F%91%8B;FullStack+Developer+%7C+Web+%26+Mobile;Java+%7C+Spring+Boot+%7C+Flutter;Building+software+for+the+glory+of+God+%E2%9C%9D%EF%B8%8F
typing-pt.svg|https://readme-typing-svg.herokuapp.com/?color=D4AF37&size=28&center=true&width=600&lines=Ol%C3%A1%2C+eu+sou+o+Victor+%F0%9F%91%8B;Desenvolvedor+FullStack+%7C+Web+%26+Mobile;Java+%7C+Spring+Boot+%7C+Flutter;Construindo+software+para+a+gl%C3%B3ria+de+Deus+%E2%9C%9D%EF%B8%8F
typing-es.svg|https://readme-typing-svg.herokuapp.com/?color=D4AF37&size=28&center=true&width=600&lines=Hola%2C+soy+Victor+%F0%9F%91%8B;Desarrollador+FullStack+%7C+Web+%26+Mobile;Java+%7C+Spring+Boot+%7C+Flutter;Construyendo+software+para+la+gloria+de+Dios+%E2%9C%9D%EF%B8%8F
streak-en.svg|https://streak-stats.demolab.com?user=VictorHJesusSantiago&theme=monokai&hide_border=false&ring=D4AF37&fire=D4AF37&currStreakLabel=D4AF37&border=D4AF37&locale=en&date_format=j%20M%5B%20Y%5D
streak-pt.svg|https://streak-stats.demolab.com?user=VictorHJesusSantiago&theme=monokai&hide_border=false&ring=D4AF37&fire=D4AF37&currStreakLabel=D4AF37&border=D4AF37&locale=pt_BR&date_format=j%20M%5B%20Y%5D
streak-es.svg|https://streak-stats.demolab.com?user=VictorHJesusSantiago&theme=monokai&hide_border=false&ring=D4AF37&fire=D4AF37&currStreakLabel=D4AF37&border=D4AF37&locale=es&date_format=j%20M%5B%20Y%5D
skills-frontend.svg|https://skillicons.dev/icons?i=html,css,js,bootstrap&theme=dark
skills-backend.svg|https://skillicons.dev/icons?i=java,spring,python,flask,ts,cs,dotnet&theme=dark
skills-databases.svg|https://skillicons.dev/icons?i=mysql,sqlite,mongodb,prisma&theme=dark
skills-tools.svg|https://skillicons.dev/icons?i=git,androidstudio&theme=dark
wakatime.svg|https://github-readme-stats.vercel.app/api/wakatime?username=VictorHJesusSantiago&theme=monokai&hide_border=false&title_color=D4AF37&icon_color=D4AF37&border_color=D4AF37&layout=compact
banner-header-new.svg|https://capsule-render.vercel.app/api?type=waving&color=0079FF,090C12&height=160&section=header&text=Victor%20H.%20J.%20Santiago&fontSize=40&fontColor=ffffff&fontAlignY=40&desc=FullStack%20Developer%20%7C%20Soli%20Deo%20Gloria%20%E2%9C%9D%EF%B8%8F&descAlignY=62&descSize=17&animation=fadeIn&reversal=true
banner-footer-new.svg|https://capsule-render.vercel.app/api?type=waving&color=090C12,0079FF&height=120&section=footer&animation=fadeIn&reversal=true
stats-new.svg|https://github-readme-stats.vercel.app/api?username=VictorHJesusSantiago&show_icons=true&theme=tokyonight&title_color=0079FF&icon_color=0079FF&border_color=0079FF&hide_border=false&count_private=true
top-langs-new.svg|https://github-readme-stats.vercel.app/api/top-langs/?username=VictorHJesusSantiago&layout=compact&theme=tokyonight&title_color=0079FF&border_color=0079FF&hide_border=false&langs_count=8
streak-new.svg|https://streak-stats.demolab.com?user=VictorHJesusSantiago&theme=tokyonight&hide_border=false&ring=0079FF&fire=00D4FF&currStreakLabel=0079FF&border=0079FF&locale=en&date_format=j%20M%5B%20Y%5D
EOF
)

while IFS="|" read -r name url; do
  [ -z "$name" ] && continue
  dest="assets/readme/$name"
  tmp="$(mktemp)"
  if curl -fsSL --max-time 60 "$url" -o "$tmp" && [ -s "$tmp" ] && head -c 256 "$tmp" | grep -qi '<svg'; then
    mv "$tmp" "$dest"
    echo "updated $name"
  else
    echo "skipped $name (source unavailable or invalid response, keeping cached copy)"
    rm -f "$tmp"
  fi
done <<< "$ASSETS"
