# Benchmark de diversidade para seleção de híbridos

```
Rscript tests/test_metrics.R   # checagens de sanidade (~10 s)
Rscript run_all.R              # benchmark completo -> report/ (~6 min)
```

Configuração atual: 50+50 linhagens → 2500 híbridos, 5000 marcadores, seleciona 100 (4%).
Para a escala real, edite `sim_config` em `R/00_data.R` (`n_pool_A/B = 71`, `m = 25000`)
ou troque `load_data()` pelos seus arquivos.

| Arquivo | Papel |
|---|---|
| `R/00_data.R` | simulação, `G` de VanRaden (predição), `f` coancestria molecular (diversidade). `load_data()` é o único ponto a trocar |
| `R/01_metrics.R` | as métricas, todas `f(idx, ctx) -> escalar` |
| `R/02_benchmark.R` | nula, poder discriminatório, custo, gráficos |
| `R/03_de_select.R` | estratégias de seleção: truncamento, cap parental, greedy, DE, relaxamento OCS |

## Resultados (dados simulados)

**1. Use `f` (coancestria molecular), não a `G` de VanRaden, para diversidade.**
Com `Z` centrada na própria população, `sum(G) == 0` exatamente — medido: `-3.2e-12`.
`Ns = 1/(2θ)` sobre `G` daria `-3.3e+15`. `G` continua para a predição dos traits.

**2. `1 − θ` e `He` de Nei são a mesma quantidade.** `cor = 1.0000000000` na nula,
e identidade até `1e-10` no teste. Uma métrica a menos, e "perder 5% da diversidade"
passa a ter significado exato: 5% da heterozigosidade esperada.

**3. Sua métrica atual está quase certa.** `cor(GD, off-diagonal) = −1.0000`.
Em população toda-F1 a diagonal de `f` varia pouco, então a média off-diagonal
ordena igual. O que faltava não era a diagonal — era **o baseline e a escala**.

**4. O baseline importa mais que a métrica.** `GD` da população (N=2500) = 0.32744;
média de subconjuntos aleatórios de 100 = 0.32603. Comparar direto com a matriz
5000×5000 registra **0.43% de perda que é puro efeito de amostragem**, não seleção.

**5. Seu limite de 5% não restringe nada.** O truncamento puro — a seleção mais
gananciosa possível — perde só **3.63%**. Nenhuma seleção de 100 entre 2500 chega
a 5%. Faixa útil de α neste dataset: **0 a 3,6%**. Joelho da curva perto de
**α ≈ 1,5%**, onde o DE entrega 1.86 dos 2.30 desvios do truncamento (81% do ganho)
com 40% da perda de diversidade. Recalcular na sua matriz real antes de fixar o número.

**6. Métricas que sobrevivem** (desvios da nula, truncamento vs aleatório):

| Métrica | z | Veredito |
|---|---|---|
| `GD` / `Ns` / off-diagonal | ±30 | Núcleo. Entram no fitness (33 µs) |
| `eff_dim` | −35 | Melhor discriminador, mas 366 µs e redundante com `GD` |
| `ANE` (representatividade) | +42 | Independente. Pós-hoc, 2300 µs |
| `alleles_lost` | +26 | Independente de θ. Pós-hoc |
| `Ne_parents` | −16 | Independente e grátis (0 µs). **Entra no fitness** |
| `ENE` (não-redundância) | −3 | Fraco aqui: não há clones no conjunto |

`Ne_parents` cai de 69 (aleatório) para 19 (truncamento) enquanto `Ns` cai só de
0.742 para 0.729. É a métrica que enxerga o que a coancestria borra — e custa zero.

**7. DE precisa de warm start.** Sem semear a população com as soluções greedy,
o DE fica *abaixo* do greedy (450k avaliações não bastam para 100 dimensões inteiras).
Com warm start ele fica 0.03–1.19 acima do greedy e encosta no relaxamento contínuo
de OCS (gap ~0 no extremo). O DE satura a restrição exatamente (α obtido ≈ α_max),
que é o sinal de que a formulação por restrição está funcionando.

## Ressalvas

- `Ns = 1/(2θ)` é descritor estático do grupo, não projeção de deriva. Não usar
  `Ne = 1/(2ΔF)` sob gestão molecular (Toro et al. 2020).
- G aditivo de VanRaden não captura heterose/SCA. Afeta a predição dos traits,
  não as métricas de diversidade.
- `theta_A/B/AB` (decomposição por grupo heterótico) está implementado e no CSV,
  mas na simulação os pools são simétricos por construção — na sua matriz real é
  onde vale olhar primeiro.
