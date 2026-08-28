# Métricas de diversidade genética na era genômica
### Leitura crítica de Meuwissen, Sonesson, Gebregiwergis & Woolliams (2020), *Front. Genet.* 11:880 — com tradução para o contexto de melhoramento de plantas

---

## 1. A tese central em uma frase

Na teoria clássica, endogamia medida por **perda de heterozigose** e endogamia medida por **deriva de frequências alélicas** são a mesma coisa. O artigo mostra que, dentro de esquemas de **contribuição ótima genômica (GOC)**, elas deixam de ser a mesma coisa — e podem divergir brutalmente — sempre que o controle de diversidade é feito sobre **identidade por estado (IBS)** em um painel de marcadores. Só quando o controle é feito sobre **identidade por descendência (IBD)** a equivalência clássica se restabelece.

A consequência prática é desconfortável: **você atinge exatamente a meta que escreveu na restrição do otimizador, e paga um preço não monitorado na métrica que você não escreveu.**

> Para o melhorista de plantas: se você restringe `½c′Gc` usando uma matriz G de VanRaden, você está restringindo deriva. A perda de heterozigose no seu germoplasma pode estar correndo ao dobro da taxa que você acredita estar controlando.

---

## 2. Mapa das medidas: três lentes, não três sinônimos

| Lente | O que a métrica realmente enxerga | Métrica de endogamia | Matriz de parentesco correspondente |
|---|---|---|---|
| **Deriva** | Mudança quadrática de frequência alélica em relação a uma base | `F_drift` | `G_VR2`, `G_VR1`, `G_i(p)` |
| **Homozigose** | Proporção de heterozigose remanescente | `F_hom` | `G_0.5` (coancestria molecular) |
| **IBD** | Segmentos herdados por descendência de uma base definida | `F_IBD` | `A`, `G_LA` |
| **Híbrido** | Homozigose de haplótipos usada como *proxy* de IBD | `F_ROH` | `G_ROH` |

Toda métrica de endogamia é uma **razão em relação a uma população de referência**. Sem declarar explicitamente qual é a sua base (ciclo 0 do programa recorrente? painel de landraces? pool heterótico fundador?), nenhum dos números abaixo tem significado. Este é o erro mais comum na aplicação em plantas: usar as frequências da geração corrente como base, o que zera a memória histórica da erosão.

---

## 3. As métricas, uma a uma

### 3.1 Taxa de endogamia `ΔF` e tamanho efetivo `Ne`

**Conceito.** A quantidade que realmente se gerencia não é `F`, e sim a sua *taxa de acumulação por ciclo*. `F` é um estoque; `ΔF` é o fluxo.

$$\Delta F = \frac{F_t - F_{t-1}}{1 - F_{t-1}} \qquad ; \qquad N_e = \frac{1}{2\Delta F}$$

**Estimação a partir da série temporal.** Como `1 - F_t = (1 - ΔF)^t`, uma regressão de `log(1 - F_t)` contra `t` tem coeficiente angular `≈ -ΔF`. A linearidade dessa regressão é, por si só, um diagnóstico: no artigo, `log(1 - F_drift)` foi aproximadamente linear em todos os esquemas, enquanto `log(1 - F_hom)` mostrou curvatura marcada em alguns (notadamente o esquema baseado em ROH). **Curvatura significa taxa não constante — sua meta de `Ne` não está sendo cumprida de forma estável.**

**Exemplo em plantas.** Programa recorrente de milho tropical, meta `Ne = 50` por ciclo → `ΔF = 0.01`. Se você mede `F` apenas no ciclo 8 e divide por 8, você mascara a possibilidade de que os ciclos 1–3 tenham sido conservadores e os ciclos 6–8 tenham colapsado a base. Ajuste sempre a regressão log-linear e olhe o resíduo.

---

### 3.2 `F_hom` — endogamia baseada em homozigose

**Conceito.** Wright definiu que um coeficiente de endogamia natural vai de 0 a 1 conforme a heterozigose sob acasalamento aleatório cai do estado inicial a zero. Logo, a métrica é a fração de heterozigose já perdida em relação à base:

$$F_{hom} = 1 - \frac{1}{N_{SNP}}\sum_{k} \frac{2p_{t,k}(1-p_{t,k})}{2p_{0,k}(1-p_{0,k})} = 1 - \frac{1}{N_{SNP}}\sum_k \frac{H_{t,k}}{H_{0,k}}$$

**Propriedade crítica.** `F_hom` **pode ser negativa**. Se a gestão empurra frequências para 0.5, a heterozigose sobe acima da base e o "coeficiente de endogamia" fica abaixo de zero. Isso não é erro numérico: é o comportamento esperado de qualquer esquema que maximize heterozigose no painel monitorado.

**O que ela protege.** Depressão por endogamia e expressão de recessivos deletérios em homozigose. É a lente certa quando o risco dominante é *vigor*.

**Exemplo em plantas.** Em milho, a heterozigose é o próprio produto (heterose). Em um pool heterótico sob seleção recorrente recíproca, `F_hom` calculada **dentro de pool** é a métrica que antecipa a queda de vigor da linhagem *per se*; ela nada diz sobre a divergência entre pools, que é o que gera heterose no híbrido. Em espécies autógamas (soja, trigo, arroz), `F_hom` medida em linhagens fixadas é ≈ 1 por construção e **é inútil como métrica de gestão** — o cálculo tem que ser feito sobre frequências alélicas na população de cruzamentos, não sobre a homozigose dos indivíduos.

---

### 3.3 `F_drift` — endogamia baseada em deriva

**Conceito.** Mede a mudança quadrática de frequência acumulada desde a base, escalonada pela variância máxima possível daquele locus:

$$F_{drift} = \frac{1}{N_{SNP}}\sum_k \frac{(p_{t,k} - p_{0,k})^2}{p_{0,k}(1-p_{0,k})} = \frac{1}{N_{SNP}}\sum_k \frac{\delta p_{t,k}^2}{p_{0,k}(1-p_{0,k})}$$

**Propriedades.** Nunca é negativa. É formalmente análoga ao `F_ST` de Holsinger & Weir, aplicado a **uma população ao longo do tempo** em vez de a um conjunto de populações no espaço. É exatamente a quantidade restringida quando se usa `G_VR2` no otimizador.

**O que ela protege.** Contra mudanças aleatórias de valor fenotípico em caracteres **fora** do objetivo de seleção, contra a subida de recessivos deletérios raros a frequências perigosas, e contra a perda irreversível de alelos raros.

**Interpretação como intensidade de seleção.** O termo `δp²/[p₀(1-p₀)]` é uma aproximação da **intensidade total ao quadrado** aplicada àquele marcador, com `i ≈ δp/√[p₀(1-p₀)]`. Restringir `F_drift` é, portanto, restringir quanta "seleção efetiva" o genoma inteiro sofreu — inclusive nos locos que você não queria selecionar.

**Exemplo em plantas.** Um programa de trigo que usou GS por 6 ciclos com `G` de VanRaden e reportou `ΔF ≈ 1%`: esse número é `ΔF_drift` no painel de treinamento. Locos de resistência quantitativa a doenças ainda não priorizados podem ter derivado a frequências extremas por carona (*hitch-hiking*) com QTLs de produtividade, e nada disso aparece na métrica reportada.

---

### 3.4 A equivalência clássica — e a covariância que a destrói

Sob deriva puramente aleatória, com `E[δp_t | p₀] = 0` para todo `p₀`:

$$\frac{\text{var}(p_{t,k})}{p_0(1-p_0)} = 1 - \frac{H_t}{H_0} \;\;\Longrightarrow\;\; F_{drift} = F_{hom}$$

O resultado central do artigo é a quantificação do desvio:

$$F_{hom} - F_{drift} = 2\,\text{cov}\!\left(\frac{\delta p_{t,k}}{\sqrt{p_{0,k}(1-p_{0,k})}}\,,\; \frac{p_{0,k} - 1/2}{\sqrt{p_{0,k}(1-p_{0,k})}}\right)$$

Em palavras: **se a direção da mudança de frequência estiver correlacionada com a frequência inicial, as duas medidas divergem.** E o ponto não trivial é que essa covariância é induzida **pela própria gestão de diversidade**, não pela seleção direcional. O artigo comprova isso rodando o esquema com GEBVs aleatórios: a divergência persiste.

**Por que cada matriz gera um sinal de covariância:**

- **`G_VR2` → covariância positiva.** Como a restrição penaliza `δp²`, mover um alelo para o extremo *mais distante* custa mais que movê-lo para o extremo *mais próximo*. O otimizador então empurra sistematicamente os alelos raros para 0 e os comuns para 1. Resultado: deriva "barata" na métrica, homozigose real disparando. No artigo, `F_hom − F_drift = 0.147` no painel gerenciado.
- **`G_0.5` → covariância negativa.** As frequências são medidas como desvios de 0.5, então o otimizador ganha "diversidade" empurrando tudo para frequências intermediárias. `F_hom` fica negativa (−0.348 de desvio), mas `F_drift` explode: 0.0213/ciclo contra a meta de 0.005.
- **`G_VR1` → positiva, porém atenuada.** É `G_VR2` reponderada por `2p₀(1-p₀)`, o que dá mais peso a locos já intermediários e reduz o campo de manobra nos extremos.
- **`G_i(p)` → covariância negativa (sinal invertido).** Ao usar intensidade acumulada em vez de `δp²`, e como `di/dp = [p(1-p)]^{-1/2}`, movimentos rumo aos extremos ficam mais caros. Inverte o sinal do viés, mas não o elimina.

**Magnitude depende do espectro de MAF.** É por isso que o efeito é dramático com dados de sequência (WGS), dominados por alelos raros, e muito mais brando com chips de SNP, desenhados para MAF intermediária. **Tradução direta para plantas: quem usa GBS/skim-seq com todo o espectro de MAF está no cenário severo; quem usa um chip de 20–50k selecionado para MAF > 0.05 está no cenário brando.**

---

### 3.5 `F_IBD` via `G_LA` — endogamia por descendência

**Conceito.** Em vez de assumir probabilidade 50/50 de transmissão de cada alelo parental (como faz a matriz `A`), usa-se **análise de ligação** sobre os marcadores para inferir qual haplótipo parental foi de fato transmitido, ao longo do cromossomo. Requer pedigree **e** marcadores.

**Por que funciona.** `G_LA` mede IBD relativo a uma base explicitamente definida como não-aparentada e não-endogâmica. A mudança de frequência passa a ser determinada pelas propriedades da população base e não pelo desequilíbrio de ligação gerado durante a seleção — e a covariância problemática desaparece. Foi **o único esquema testado que cumpriu simultaneamente as metas de `ΔF_hom` e `ΔF_drift`**, tanto no painel gerenciado quanto nos locos neutros não monitorados, e o que mais eficientemente converteu endogamia em ganho.

**Custo.** Computacional. O próprio artigo teve que substituir o algoritmo exato (LDMIP) por uma aproximação baseada em haplótipos para viabilizar 100 repetições.

**Exemplo em plantas.** Este é o ponto de maior atrito na transposição. Em populações biparentais e em famílias de retrocruzamento, `G_LA` é natural e barato — a fase é conhecida e o número de meioses desde a base é pequeno. Em populações de seleção recorrente com pedigree completo (comum em milho comercial), é viável. Em painéis de germoplasma *sem pedigree* (bancos de germoplasma, coleções nucleares), `G_LA` é inaplicável e a alternativa honesta é IBD baseado em segmentos haplotípicos longos.

---

### 3.6 `F_ROH` e `G_ROH` — corridas de homozigose

**Conceito.** Um ROH é um trecho ininterrupto de marcadores homozigotos. A lógica: é improvável que muitos marcadores consecutivos sejam IBS por acaso, logo o trecho provavelmente é IBD.

$$F_{ROH} = \frac{\sum \text{comprimento dos ROH}}{\text{comprimento total do genoma}}$$

**Ambiguidade fundamental.** `F_ROH` é IBD quando os ROH são **longos** (endogamia recente) e é homozigose quando são **curtos** (endogamia antiga, IBS acumulado). O limiar de comprimento mínimo é, portanto, um botão que escolhe a *idade* da endogamia que você está medindo — e não existe base de referência bem definida.

**Comportamento empírico no artigo.** `G_ROH` se comportou mais como `G_0.5` (medida de homozigose) do que como uma medida de IBD; produziu ganho genético altíssimo (9.099) com `F_hom` baixo (0.08), mas com `F_drift` estourando a meta (0.15). Além disso, `G_ROH` **não é garantidamente semidefinida positiva** — seus elementos são calculados par a par — e exigiu adição de valores substanciais à diagonal (em média 8.7) para inversão, o que a tornou diagonalmente dominante e inflou artificialmente o número de parentais selecionados.

**Exemplo em plantas.** ROH é atraente em culturas clonais e em autógamas, onde segmentos homozigotos longos são a regra. Mas em uma linhagem endogâmica de soja o genoma inteiro é um ROH — `F_ROH ≈ 1` e a métrica satura. Em milho, ROH é útil para diagnosticar erosão de pools heteróticos elite; para *gestão* em otimizador, cuidado redobrado com a positividade da matriz.

---

### 3.7 As matrizes de parentesco, lado a lado

| Matriz | Construção | Classe | Comportamento no otimizador |
|---|---|---|---|
| `A` | Pedigree | IBD (esperança) | Alto ganho, mas excedeu as metas em ~40% por não contabilizar LD dentro de famílias |
| `G_VR2` | `XX′/N_SNP`, padronizada por `p₀` | Deriva | Cumpre `ΔF_drift` **só no painel gerenciado**; `ΔF_hom` dispara |
| `G_VR1` | `ZZ′/Σ2p₀(1-p₀)` | Deriva | Versão reponderada; viés menor, ganho menor |
| `G_0.5` | Base fixada em 0.5 → coancestria molecular | Homozigose | `ΔF_hom` quase nulo, `ΔF_drift` 4× a meta; **perde variância genética cedo** |
| `G_i(p)` | Intensidade acumulada ao quadrado | Deriva | Inverte o sinal do viés; restrição só indiretamente ligada a `F` |
| `G_LA` | Análise de ligação (pedigree + marcadores) | IBD | Único a cumprir ambas as metas; maior ganho por unidade de endogamia |
| `G_ROH` | Homozigose de haplótipos, par a par | Híbrida | Ganho alto, deriva descontrolada, problemas numéricos |

**Nota de implementação frequentemente ignorada.** `G_VR1`, `G_VR2`, `G_0.5` e `G_i(p)` são apenas **semi**definidas positivas (autovalor zero pela centralização). É preciso somar `α` à diagonal (`α = 0.01` no artigo) para inverter e para que o algoritmo de contribuição ótima funcione. `A` e `G_LA` são definidas positivas por construção.

---

### 3.8 Coancestria de grupo e a formulação da contribuição ótima

A quantidade gerenciada em OCS é a **coancestria de grupo dos pais selecionados**:

$$\mathcal{K} = \tfrac{1}{2}\mathbf{c}^{\prime}\mathbf{G}\mathbf{c}$$

onde `c` é o vetor de contribuições fracionárias (proporcional ao número de descendentes). O problema:

$$\max_{\mathbf{c}} \; \bar{g} = \mathbf{c}^{\prime}\hat{\mathbf{g}} \quad \text{s.a.} \quad \tfrac{1}{2}\mathbf{c}^{\prime}\mathbf{G}\mathbf{c} \le \mathcal{K}_t, \;\; \sum_{\text{machos}} c_j = \sum_{\text{fêmeas}} c_j = \tfrac{1}{2}, \;\; c_j \ge 0$$

A meta é imposta recursivamente: `K_t = K_{t-1} + ΔF_alvo · (1 - K_{t-1})`, com `K₀ = ½Ḡ`.

**Adaptação para plantas.** A restrição de soma por sexo desaparece em espécies hermafroditas/monoicas (soma única = 1), mas reaparece em culturas dioicas e em esquemas com macho-esterilidade citoplasmática. Em milho híbrido, o problema natural não é OCS mas **seleção ótima de cruzamentos**: `c` deixa de ser contribuição individual e passa a ser peso de cada cruzamento, com a covariância entre pools entrando explicitamente. E há uma restrição adicional que a literatura animal não tem: **número máximo de cruzamentos executáveis por campo**, que torna o problema inteiro-misto.

---

### 3.9 Ganho por unidade de endogamia — a métrica de eficiência

Não compare esquemas por ganho absoluto nem por `F` absoluto: compare a **trajetória** de `G_t` contra `-log(1 - F_t)`, que lineariza a escala de endogamia. O artigo mostra que o *ranking* dos esquemas **muda conforme a lente**: `G_ROH` e `G_i(p)` parecem excelentes contra `F_hom` e medíocres contra `F_drift`; `G_VR2` faz exatamente o oposto. Reportar apenas uma das curvas é, na prática, escolher o resultado.

---

### 3.10 Variância genética e número de parentais — as métricas de diagnóstico

- **Variância genética verdadeira ao longo do tempo.** `G_0.5` perdeu variância cedo e nunca recuperou: forçar frequências a 0.5 no *painel* não mantém variação nos QTLs. `G_LA` foi o que menos perdeu variância aos 20 ciclos.
- **Número de parentais selecionados.** Esquemas IBD (`A`, `G_LA`) e `G_ROH` selecionaram muitos parentais; os esquemas ao estilo VanRaden selecionaram poucos. Selecionar poucos parentais e ainda assim cumprir a restrição é o sintoma visível de que o otimizador está explorando a covariância `cov(δp, p₀)` em vez de realmente evitar aparentados.

> **Regra de bolso de diagnóstico:** se seu OCS está entregando ganho alto com um número de parentais suspeitamente pequeno e `ΔF` na meta, calcule `F_hom` e `F_drift` separadamente em um painel **não usado** na gestão. A diferença entre os dois é a sua fatura oculta.

---

## 4. Resultados quantitativos de referência

Meta de `ΔF` = 0.005/geração (`Ne` = 100 alvo). Valores nos **locos neutros não monitorados** (Painel N), geração 20.

| Esquema | Classe | `ΔF_hom` | `ΔF_drift` | `F_hom − F_drift` | Ganho (σ_g) | `F_hom` | `F_drift` |
|---|---|---|---|---|---|---|---|
| `G_VR2(M,M)` | Deriva | 0.0103 | 0.0068 | +0.054 | 7.124 | 0.18 | 0.12 |
| `G_VR2(M,D)` | Deriva | 0.0101 | 0.0068 | +0.050 | 7.107 | 0.17 | 0.12 |
| `G_VR1(M,M)` | Deriva | 0.0080 | 0.0069 | +0.021 | 6.680 | 0.15 | 0.12 |
| `G_i(p)(M,M)` | Deriva | 0.0065 | 0.0077 | −0.031 | 7.111 | 0.11 | 0.14 |
| `G_0.5(M,M)` | Homozigose | 0.0073 | 0.0176 | −0.170 | 6.734 | 0.13 | 0.30 |
| `G_ROH(M,M)` | Homozigose | 0.0054 | 0.0088 | −0.070 | 9.099 | 0.08 | 0.15 |
| **`G_LA(M,M)`** | **IBD** | **0.0043** | **0.0049** | **−0.010** | **7.188** | **0.08** | **0.09** |
| `A(M,~)` | IBD | 0.0070 | 0.0084 | −0.021 | 9.890 | 0.12 | 0.14 |

Leitura rápida:

1. **Nenhum esquema IBS cumpriu ambas as metas.** `G_LA` cumpriu, com desvio de ~2%.
2. `A` (pedigree) deu o maior ganho absoluto, mas excedeu as metas em ~40% — carona de locos neutros com QTLs via LD dentro de família, que a esperança de IBD por pedigree não captura.
3. Usar um painel separado para gestão (`M,D`) em vez do mesmo painel de GEBV mudou o ganho em **menos de 0.3%**. Não vale a complexidade.
4. Aos mesmos níveis médios de endogamia, `G_LA` superou `A` em 65 de 100 repetições e `G_ROH` em 62 de 100 (P < 0.01).

---

## 5. O que transportar para o melhoramento de plantas

**5.1 Declare a base e nunca a redefina.** O erro metodológico apontado no artigo em relação a de Beukelaer et al. (2017) — redefinir as frequências de referência a cada geração — é comum em pipelines de plantas, porque é o *default* de várias funções de construção de `G`. Como as mudanças de frequência em ciclos sucessivos são positivamente correlacionadas, restringir a variância *dentro* de cada ciclo deixa a variância *acumulada* estourar a meta. **Congele `p₀` do ciclo fundador e propague-o.**

**5.2 Seu espectro de MAF define a gravidade do problema.** Chip com MAF filtrada > 0.05 → discrepância presente mas moderada. GBS/skim-seq/WGS com todo o espectro → discrepância severa. Este é o parâmetro que decide se você pode conviver com `G_VR2` ou não.

**5.3 Não maximize heterozigose de marcadores como objetivo.** Elevar a heterozigose do painel monitorado não eleva a heterozigose dos locos não monitorados — e ainda aumenta IBD real, porque subir a frequência de um alelo significa multiplicar cópias de um subconjunto de alelos da base. Em melhoramento de plantas, isso mata a tentação de usar "maximizar heterozigosidade média" como critério de composição de populações-base.

**5.4 Pools heteróticos precisam de restrição bidirecional.** Dentro de pool, você quer limitar `ΔF`. Entre pools, você quer *preservar* a divergência — que é deriva dirigida e desejável. Uma única restrição `½c′Gc` global não expressa isso. Use matrizes múltiplas com restrições simultâneas (a abordagem de Dagnachew & Meuwissen e Gómez-Romano et al. citada no artigo) ou restrições por sub-população.

**5.5 Autógamas exigem separar endogamia por autofecundação de endogamia por deriva.** Em soja, trigo ou arroz, `F` do indivíduo é ≈1 por design e não carrega informação de gestão. A métrica gerenciável é a frequência alélica **na população de cruzamentos** e a coancestria entre os parentais escolhidos. Todo o arcabouço `F_hom`/`F_drift` deve ser aplicado no nível da população, nunca no nível da linhagem.

**5.6 Regiões prioritárias raramente valem a complexidade.** O artigo é cético quanto a priorizar regiões genômicas específicas para diversidade — as variantes causais são bem distribuídas e o que ocorre em um subconjunto de locos não prevê o que ocorre fora dele. Exceções legítimas em plantas: locos de resistência do tipo R-gene (análogos funcionais ao MHC citado no artigo), onde diversidade alélica tem valor direto e conhecido.

**5.7 Recessivos deletérios são um problema de carga, não de diversidade.** Se você já mapeou o defeito, incluí-lo no índice de seleção é mais eficiente do que tentar controlá-lo indiretamente via restrição de diversidade. Isso vale igualmente para carga genética em milho e para letais embrionários em espécies clonais.

**5.8 Em esquemas de conservação puro (bancos de germoplasma), o problema é *pior*, não melhor.** Sem seleção direcional, o termo de gestão de endogamia domina o otimizador, e a covariância `cov(δp, p₀)` tende a ser maior. Aqui a recomendação IBD é ainda mais forte.

---

## 6. Implementação em R

### 6.1 Métricas fundamentais

```r
# ---- Fhom e Fdrift ancorados na base p0 --------------------------------
# p0, pt: vetores de frequências alélicas (mesmo alelo de referência!) 
#         de comprimento n_snp. p0 vem da GERAÇÃO FUNDADORA, congelada.

f_hom <- function(p0, pt, min_maf = 1e-6) {
  keep <- p0 > min_maf & p0 < 1 - min_maf
  H0 <- 2 * p0[keep] * (1 - p0[keep])
  Ht <- 2 * pt[keep] * (1 - pt[keep])
  1 - mean(Ht / H0)                     # pode ser NEGATIVO: isso é esperado
}

f_drift <- function(p0, pt, min_maf = 1e-6) {
  keep <- p0 > min_maf & p0 < 1 - min_maf
  dp <- pt[keep] - p0[keep]
  mean(dp^2 / (p0[keep] * (1 - p0[keep])))
}

# ---- A covariância diagnóstica (Eq. 3) --------------------------------
cov_diagnostica <- function(p0, pt, min_maf = 1e-6) {
  keep <- p0 > min_maf & p0 < 1 - min_maf
  s  <- sqrt(p0[keep] * (1 - p0[keep]))
  x  <- (p0[keep] - 0.5) / s            # desvio padronizado de 1/2
  y  <- (pt[keep] - p0[keep]) / s       # mudança padronizada
  fit <- lm(y ~ x)
  list(
    delta_esperado = 2 * cov(x, y),     # deve reproduzir Fhom - Fdrift
    delta_obs      = f_hom(p0, pt) - f_drift(p0, pt),
    slope          = unname(coef(fit)[2]),
    p_valor        = summary(fit)$coefficients[2, 4],
    r              = cor(x, y)
  )
}
```

Note que uma correlação de apenas **0.040** foi suficiente para gerar uma discrepância de 0.055 em `F` no artigo. Não descarte o diagnóstico por "correlação baixa" — olhe o produto `2·cov`, não o `r`.

### 6.2 Taxas por regressão log-linear

```r
taxa_endogamia <- function(F_serie, geracoes = seq_along(F_serie)) {
  y   <- log(1 - F_serie)
  fit <- lm(y ~ geracoes)
  list(
    delta_F   = -unname(coef(fit)[2]),
    Ne        = 1 / (2 * -unname(coef(fit)[2])),
    r2        = summary(fit)$r.squared,   # r2 baixo = taxa NÃO constante
    curvatura = summary(lm(y ~ poly(geracoes, 2)))$coefficients[3, 4]
  )
}
```

### 6.3 Construção das matrizes

```r
# M: matriz n x m de dosagens {0,1,2}; p0: frequências da base congelada
G_vanraden2 <- function(M, p0, alpha = 0.01) {
  X <- sweep(M, 2, 2 * p0, "-")
  X <- sweep(X, 2, sqrt(2 * p0 * (1 - p0)), "/")
  G <- tcrossprod(X) / ncol(M)
  diag(G) <- diag(G) + alpha            # semi-definida -> definida positiva
  G
}

G_vanraden1 <- function(M, p0, alpha = 0.01) {
  Z <- sweep(M, 2, 2 * p0, "-")
  G <- tcrossprod(Z) / sum(2 * p0 * (1 - p0))
  diag(G) <- diag(G) + alpha
  G
}

# G_0.5: base fixada em 0.5 -> proporcional à coancestria molecular
G_meio <- function(M, alpha = 0.01) G_vanraden2(M, p0 = rep(0.5, ncol(M)), alpha)
```

Para `A`: `AGHmatrix::Amatrix()`. Para OCS com restrição quadrática: `optiSel::opticont()`, que aceita `G` arbitrária e restrições múltiplas simultâneas — exatamente o que a Seção 5.4 exige para pools heteróticos.

### 6.4 Núcleo em C++ quando `n` cresce

Com painéis de germoplasma grandes (`n > 5.000`), o gargalo é o produto cruzado e as avaliações repetidas de `c′Gc` dentro do otimizador. Vale delegar:

```cpp
// [[Rcpp::depends(RcppEigen)]]
#include <RcppEigen.h>

// [[Rcpp::export]]
Eigen::MatrixXd grm_vr2(const Eigen::Map<Eigen::MatrixXd> M,
                        const Eigen::Map<Eigen::VectorXd> p0,
                        double alpha = 0.01) {
  const int m = M.cols();
  Eigen::MatrixXd X = M;
  for (int k = 0; k < m; ++k) {
    const double s = std::sqrt(2.0 * p0(k) * (1.0 - p0(k)));
    X.col(k) = (X.col(k).array() - 2.0 * p0(k)) / s;
  }
  Eigen::MatrixXd G = (X * X.transpose()) / static_cast<double>(m);
  G.diagonal().array() += alpha;
  return G;
}
```

Dentro do laço do otimizador, pré-fatore `G` uma única vez (Cholesky) e reutilize — a decomposição também serve como teste de positividade definida, que é precisamente o procedimento que o artigo teve que aplicar iterativamente a `G_ROH`.

---

## 7. Limites da transposição animal → planta

| Premissa do artigo | Situação em plantas |
|---|---|
| Gerações discretas, dois sexos, uma contribuição por indivíduo | Hermafroditismo, autofecundação, clonagem, sobreposição de ciclos, uso repetido do mesmo parental |
| Pedigree confiável e profundo | Frequentemente truncado, ou ausente em bancos de germoplasma |
| Base = população fundadora simulada em equilíbrio mutação-deriva | Base é uma escolha administrativa (ciclo 0 do programa), com estrutura preexistente |
| Ne alvo = 100, 20 gerações | Ciclos mais curtos com GS, mas frequentemente Ne efetivo elite < 30 |
| Objetivo = uma população, um alvo | Múltiplos ambientes-alvo, interação G×E, pools heteróticos separados |
| Heterozigose é sempre desejável | Em autógamas é transitória; em híbridos é o produto final; em linhagens é indesejável |

Nada disso invalida a conclusão central — ela é uma propriedade **algébrica** do otimizador, não uma propriedade biológica da espécie. Mas altera qual matriz é praticável.

---

## 8. Checklist operacional

- [ ] A base `p₀` está congelada no ciclo fundador e documentada?
- [ ] `F_hom` e `F_drift` são calculados **separadamente** e reportados juntos?
- [ ] Existe um painel de locos **não usado na gestão** para auditoria?
- [ ] A regressão `log(1 − F)` vs. ciclo é linear (taxa constante)?
- [ ] A covariância `2·cov(δp/s, (p₀−½)/s)` é reportada como diagnóstico?
- [ ] O número de parentais selecionados é biologicamente plausível?
- [ ] A variância genética verdadeira (ou sua melhor estimativa) está sendo acompanhada?
- [ ] `G` é definida positiva antes da inversão, e o `α` adicionado está documentado?
- [ ] Se possível, existe uma alternativa IBD (segmentos, `G_LA`, ou `A` conservadora) comparada em paralelo?

---

## Referência

Meuwissen, T.H.E., Sonesson, A.K., Gebregiwergis, G. & Woolliams, J.A. (2020). Management of Genetic Diversity in the Era of Genomics. *Frontiers in Genetics* 11:880. doi: 10.3389/fgene.2020.00880 (acesso aberto, CC BY).

Obras de apoio citadas no artigo e relevantes para a transposição: VanRaden (2008); Meuwissen (1997); Sonesson et al. (2012); de Cara et al. (2013); de Beukelaer et al. (2017); Henryon et al. (2019); Woolliams et al. (2015); Gómez-Romano et al. (2016).
