# Dimensionamento de população — cruzamento amplo de milho (F1 → F4)

Simulador em R **sem dependências** (base R apenas), com bateria de 17 testes
numéricos embutida e **relatório HTML autocontido** como saída.

Grade: **N_F2 = 20 a 400, passo 20** (20 pontos), com resolução extra na faixa
pequena via replicação adaptativa.

## Como rodar

```bash
Rscript maize_wide_cross_sim.R --test          # 17 testes numéricos (~40 s)
Rscript maize_wide_cross_sim.R --quick         # grade reduzida (~35 s)
Rscript maize_wide_cross_sim.R --out=sim_out   # completo (~3 min)
```

Saídas em `sim_out/`: **`relatorio.html`** (autocontido, imagens embutidas em
base64, gráfico interativo), 9 figuras em PDF e PNG, `resultados.csv`,
`recuperacao_multilocus.csv`.

## Replicação adaptativa

O custo de uma repetição é ~proporcional a N, e a variância entre repetições é
maior em N pequeno. O script aloca repetições por `reps_for_N()`:

| N_F2 | 20–40 | 60 | 80 | 100 | 120 | 140 | 160 | 180 | ≥200 |
|---|---|---|---|---|---|---|---|---|---|
| repetições | 40 | 33 | 25 | 20 | 17 | 14 | 12 | 11 | 10 |

Isso quadruplica a replicação onde ela importa por ~18 % de custo extra
(1.610 execuções, ~3 min). Parametrizável em `rep_pivot` e `rep_max_mult`.

---

## Premissas — resumo

| # | Premissa | Consequência prática |
|---|---|---|
| P1 | Espaço simulado = **ancestralidade** (0 = P1, 1 = P2) | "Frequência alélica" = frequência de ancestralidade P1 |
| P2 | Parentais 100 % homozigotos | Todas as F1 idênticas, **Ne(F1) = 1**; dimensionar F1 é logística |
| P3 | 10 cromossomos, 1670 cM (~17 M), marcador a 2 cM | Não usar comprimentos de mapa tipo IBM (inflados) |
| P4 | Recombinação **Haldane, sem interferência**, igual nos dois sexos | Cauda da distribuição de blocos um pouco longa demais; médias não afetadas |
| P5 | Distorção por **amostragem por rejeição** (exata): gametofítica (só pólen) e zigótica | A rejeição atua no gameta inteiro → arrasta a região ligada |
| P6 | 5 esquemas: SSD, SSD+atrito 15 %, bulk (β = 6), Syn‑1, Syn‑2 | Todos terminam com H = 0,125 → comparáveis |
| P7 | O painel F4 **não é um painel de RILs** (H = 0,125) | Muda todas as fórmulas teóricas (tabela abaixo) |
| P8 | EP(p̂) estimado **entre repetições**, não entre marcadores | Marcadores ligados são autocorrelacionados |
| P9 | Não modela seleção artificial, QTL, mutação, inversões | Inversão conhecida → zerar `map$r` no intervalo |

**Viés conhecido:** com marcador a 2 cM, crossovers duplos dentro de um intervalo
não são contados. O viés é de **−2,0 %** no número de junctions, sempre para
baixo (teste T9, analítico). Use `spacing_cM = 1` se precisar de contagem fiel.

**Os distorcedores default são plausíveis, não medidos.** É o parâmetro que mais
move os resultados. Substitua `DEFAULT_DISTORTERS` pelos seus dados de
genotipagem F2 antes de usar qualquer número para decidir área.

## Identidades teóricas verificadas

Com H = heterozigose residual do painel (0,125 na F4):

| Quantidade | Fórmula | Valor na F4 | Teste |
|---|---|---|---|
| Var(dosagem por linha) | (1−H)/4 | 0,21875 | — |
| **EP(p̂)** | 0,5·√((1−H)/N) | **0,468/√N** | T5 |
| **Diversidade retida D** | 1 − (1−H)/N | 1 − 0,875/N | T4 |
| P(homozigoto P2 por locus) | (1−H)/2 | 0,4375 | Fig 6 |
| Junctions por haplótipo | A₂ = L; A₍ₜ₊₁₎ = Aₜ + L·Hₜ | 1,75·L | T6 |

O valor 0,5/√N que se costuma citar vale só em F∞.

**Intercruzamento:** cada ciclo de Syn adiciona apenas **0,5·L** junctions, não
1,0·L — a meiose extra só cria junction onde o parental é heterozigoto (H = 0,5
no estágio F2/Syn). Verificado em T10.

---

## Resultados (SSD, grade fina)

| N_F2 | D | EP(p̂) | genoma desbalanceado | min(p, 1−p) | N equivalente |
|---|---|---|---|---|---|
| 20 | 0,948 | 0,102 | 22,7 % | 0,165 | 17 |
| 40 | 0,969 | 0,075 | 9,7 % | 0,216 | 28 |
| 60 | 0,977 | 0,057 | 6,4 % | 0,227 | 37 |
| 80 | 0,979 | 0,051 | 5,7 % | 0,216 | 41 |
| 100 | 0,981 | 0,047 | 4,8 % | 0,232 | 46 |
| 120 | 0,983 | 0,041 | 3,8 % | 0,222 | 52 |
| 160 | 0,985 | 0,036 | 3,3 % | 0,256 | 60 |
| 200 | 0,985 | 0,030 | 4,1 % | 0,229 | 59 |
| 300 | 0,987 | 0,026 | 3,3 % | 0,233 | 69 |
| 400 | 0,988 | 0,022 | 3,0 % | 0,229 | 72 |

### Ganho marginal de D por +20 plantas

20→40: **+0,020** · 40→60: **+0,008** · 60→80: +0,002 · 80→120: +0,005 total ·
120→400: +0,005 total.

**O joelho está em ~60 plantas, não em 400.** A curva de diversidade é
essencialmente plana a partir de 100–120.

### Estrutura de blocos (não depende de N)

| Esquema | Junctions/hapl. (teoria) | Bloco médio (teoria) | Bloco médio (obs.) |
|---|---|---|---|
| SSD → F4 | 29,2 | 42,6 cM | 43,8 cM |
| Syn‑1 + SSD | 37,6 | 35,1 cM | 36,7 cM |
| Syn‑2 + SSD | 45,9 | 29,9 cM | 31,6 cM |

### Recuperação multilocus, P(≥1 linha homozigota P2 em k loci)

| N_F2 | k=3 | k=5 | k=8 | k=10 |
|---|---|---|---|---|
| 40 | 0,92 | 0,30 | 0,04 | 0,00 |
| 100 | 0,99 | 0,68 | 0,06 | 0,00 |
| 200 | 1,00 | 0,90 | 0,16 | 0,04 |
| 400 | 1,00 | 1,00 | 0,33 | 0,09 |

---

## Leitura

**1. A curva de diversidade satura em D ≈ 0,988, não em 1.** A distância até a
curva teórica é distorção de segregação — viés determinístico que não encolhe com
mais plantas. Na Fig 3 os picos têm a mesma altura com N = 20 e N = 400.

**2. O bulk é o pior esquema em toda a faixa.** Bulk com 400 plantas (D = 0,956)
retém menos diversidade que SSD com 40 (D = 0,969). Com um parental menos
adaptado, a seleção natural no bulk elimina justamente o germoplasma a introduzir.

**3. O tamanho do bloco não depende de N.** Depende só do número de meioses.
Contra linkage drag o instrumento é ciclo de intercruzamento, não área.

**4. As métricas saturam em N diferentes.** Não existe um "N ótimo" único:

| Objetivo | N onde satura |
|---|---|
| Diversidade retida (D) | ~100–120 |
| Pior região do genoma, min(p, 1−p) | ~60–80 |
| Precisão de p̂ do painel | **não satura** (cai como 1/√N) |
| Recuperação de 5 loci | ~200–260 |
| Recuperação de 8–10 loci | **não satura** em 400 |

### Números de trabalho

| Geração | Plantas | Racional |
|---|---|---|
| F1 | 8–15 autofecundadas | Ne = 1, decisão logística. Com 5 % de heterozigose residual nos parentais, 12 plantas já deixam o esperado de locus perdidos abaixo de 1 (Fig 9) |
| **F2** | **120** se o objetivo é reter diversidade | Acima disso, +280 plantas compram +0,005 de D |
| | **250–400** se você vai selecionar combinações multilocus ou estimar frequências do painel | São os objetivos que continuam ganhando com N |
| F3 | mesmo N (SSD, 1 semente/planta) | Não cria diversidade, só evita perdê‑la |
| F4 | linhas × 3–8 plantas | Multiplicação de semente. Plantas da mesma linha não são réplicas independentes: compartilham 87,5 % do genoma |

---

## Figuras

| Arquivo | Conteúdo |
|---|---|
| `fig1` | Diversidade retida vs N, 5 esquemas + curva teórica |
| `fig2` | EP(p̂) vs N, log‑log, + curva teórica |
| `fig3` | Perfil de ancestralidade nos 10 cromossomos, N = 20 vs N = 400 |
| `fig4` | 4a: genoma desbalanceado · 4b: frequência minoritária mínima |
| `fig5` | Distribuição do comprimento dos segmentos parentais |
| `fig6` | Recuperação multilocus vs N para k = 3, 5, 8, 10 |
| `fig7` | Genótipo gráfico: SSD N=20, SSD N=300, Syn‑2 N=300 |
| `fig8` | N equivalente do painel (mostra a saturação imposta pela distorção) |
| `fig9` | Dimensionamento da F1 com heterozigose residual nos parentais |

**Sobre o "N equivalente" (Fig 8):** N_eq = (1−H)/(1−D) responde "quantas linhas
F4 sem distorção dariam a mesma diversidade observada". É um **artifício de
comunicação, não um Ne no sentido de Wright** — converte um viés determinístico
em equivalente de deriva. Use para comparar cenários, nunca como parâmetro em
fórmula de Ne.

## Testes (`--test`)

17 verificações: base64 puro‑R contra RFC 4648, soma cumulativa vetorizada,
recombinação de Haldane, frequências genotípicas F2, queda de heterozigose
(0,50 → 0,25 → 0,125), identidades D = 1−(1−H)/N e EP = 0,5√((1−H)/N), expansão
de mapa (1,50 e 1,75), recursão de junctions com intercruzamento (2,25·L),
distorção gametofítica contra recursão exata de frequências genotípicas, partição
exata do mapa pelos blocos e viés analítico da grade.
