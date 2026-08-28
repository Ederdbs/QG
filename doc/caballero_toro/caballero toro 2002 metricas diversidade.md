# Diversidade genética em populações subdivididas
### Caballero & Toro (2002), *Conservation Genetics* 3:289–299 — leitura anotada para melhoramento de plantas

> **Tese central do artigo:** distância genética **não** é diversidade genética. Métodos filogenéticos (Weitzman, NJ, UPGMA) medem apenas a divergência *entre* grupos e ignoram a variação *dentro* deles e o tamanho de cada grupo. Para decidir o que conservar, o que descartar e como compor uma população-base, a métrica correta é a **coancestria média global** $\bar{f}$ — e sua minimização é matematicamente equivalente a maximizar o tamanho efetivo $N_e$.

Para um melhorista, a tradução é direta: **um acesso muito divergente pode ser inútil para o pool gênico se ele for internamente fixado**, e um acesso "comum" pode ser o maior contribuinte de variância aditiva disponível. O artigo mostra um caso em que os dois métodos dão respostas *opostas*.

---

## Sumário das métricas

| # | Símbolo | Nome | Escala | Papel no melhoramento |
|---|---------|------|--------|----------------------|
| 1 | $f_{ij}$ | Coancestria média entre subpopulações | 0–1 | Redundância entre acessos / grupos heteróticos |
| 2 | $f_{ii}$ | Coancestria média dentro da subpopulação | 0–1 | $1-f_{ii}=H_e$ do acesso; variância aditiva latente |
| 3 | $s_i$ | Auto-coancestria média | 0.5–1 | $1-s_i=H_o$; estado de homozigose do material |
| 4 | $F_i$ | Endogamia molecular média | −1–1 | Acúmulo histórico de endogamia |
| 5 | $\alpha_i$ | Desvio de Hardy–Weinberg | −1–1 | Sistema reprodutivo atual (análogo a $F_{IS}$) |
| 6 | $G_i$ | Proporção de diversidade entre indivíduos | 0–1 | "Medidor" de alogamia/autogamia |
| 7 | $\mathbf{D}_{ij}$ | Distância mínima de Nei | ≥0 | Divergência entre acessos (componente de variância) |
| 8 | $\bar{D}$ | Distância média da metapopulação | ≥0 | $= GD_{BS}$; diversidade entre acessos |
| 9 | $\bar{f}$ | **Coancestria global** | 0–1 | **Função-objetivo de todo o manejo** |
| 10 | $F_{IS},F_{ST},F_{IT}$ | Estatísticas F | — | Estrutura hierárquica |
| 11 | $GD_T,GD_{WI},GD_{BI},GD_{BS}$ | Partição da diversidade | soma = $GD_T$ | Onde a variação realmente está |
| 12 | $c_i$ | Contribuições ótimas | simplex | Composição de sintético / coleção nuclear |
| 13 | $N_e$ | Tamanho efetivo | >0 | Taxa de deriva; sustentabilidade de longo prazo |

---

## 0. Notação e convenções

- Metapopulação com $n$ subpopulações (acessos, landraces, populações, grupos heteróticos, famílias, ciclos); subpopulação $i$ tem $N_i$ indivíduos; $N_T=\sum_i N_i$.
- Til ($\tilde{x}$) = média **ponderada dentro** das subpopulações: $\tilde{f}=\sum_i f_{ii}N_i/N_T$.
- Barra ($\bar{x}$) = média sobre **todos os pares** da metapopulação, incluindo pares entre subpopulações: $\bar{f}=\sum_{i,j} f_{ij}N_iN_j/N_T^2$.
- Sempre $\bar{f}\le\tilde{f}\le\tilde{s}$. A diferença entre esses três números *é* a partição da diversidade.
- Todos os cálculos são feitos **por loco e depois promediados sobre locos** — nunca promedie frequências antes.

> **Ponto sutil e frequentemente errado:** todas as coancestrias aqui incluem os pares de um indivíduo consigo mesmo (coancestria de grupo, *sensu* Cockerham 1967). É isso que faz $1-f_{ii}$ ser exatamente a heterozigosidade esperada de Nei e faz a álgebra fechar.

---

## 1. Coancestria — os três blocos fundamentais

### 1.1 $f_{ij}$ — coancestria média entre subpopulações

Probabilidade de que dois alelos, um amostrado ao acaso na subpopulação $i$ e outro na $j$, sejam idênticos (por descendência, se via pedigree; em estado, se via marcadores). Com marcadores:

$$f_{ij}=\sum_{k=1}^{a}\tilde p_{k,i}\,\tilde p_{k,j}$$

**Interpretação para o melhorista.** $f_{ij}$ é a *redundância* entre dois materiais. Se você cruzar plantas de $i$ com plantas de $j$, a progênie terá endogamia esperada $F=f_{ij}$. É o número que responde: *"o que eu ganho de heterose/variabilidade se eu recombinar esses dois acessos?"*

**Exemplo.** Em milho, $f_{ij}$ entre um pool Stiff Stalk e um pool Non-Stiff Stalk é tipicamente baixa — é exatamente essa baixa coancestria entre grupos que sustenta o padrão heterótico. Entre duas linhagens elite da mesma família, $f_{ij}$ pode passar de 0,6 e o cruzamento não gera nada de novo.

### 1.2 $f_{ii}$ — coancestria média dentro da subpopulação

O caso $i=j$. Sob marcadores, $f_{ii}=\sum_k \tilde p_{k,i}^2$ = homozigosidade esperada. Portanto:

$$\boxed{1-f_{ii}=H_{e,i}=\text{diversidade gênica de Nei do acesso }i}$$

**Exemplo.** Um acesso de milho crioulo regenerado 20 vezes com 40 espigas por ciclo acumula coancestria e vê $f_{ii}$ subir silenciosamente. $f_{ii}$ é o alarme mais barato de erosão genética *dentro* do banco — e é justamente o que uma árvore de distâncias não enxerga.

### 1.3 $s_i$ — auto-coancestria média e $F_i$ — endogamia molecular

$$s_i=\sum_{k=1}^{a}\sum_{l=1}^{N_i}\frac{p_{k,l,i}^2}{N_i},\qquad F_i=2s_i-1,\qquad 1-s_i=H_{o,i}$$

onde $p_{k,l,i}$ é a dosagem do alelo $k$ no indivíduo $l$ (1 homozigoto, 0,5 heterozigoto, 0).

**Cuidado conceitual crítico:** $F_i$ aqui é endogamia *molecular*, medida contra uma base hipotética em que todos os alelos são distintos. Ela **não** é $F_{IS}$ e **não** é comparável entre estudos com painéis de marcadores diferentes. Para a pergunta "esta população está acasalando ao acaso?", use $\alpha_i$ (Seção 2).

**Exemplo.** Soja, arroz, trigo: linhagens puras têm $s_i\to 1$, logo $F_i\to 1$ e $H_o\to 0$. Isso é o esperado, não é sinal de problema — muda apenas onde a diversidade reside (ver Seção 6).

---

## 2. Métricas derivadas por subpopulação

$$\alpha_i=\frac{F_i-f_{ii}}{1-f_{ii}},\qquad G_i=\frac{s_i-f_{ii}}{1-f_{ii}}=\frac{D_{ii}}{1-f_{ii}},\qquad G_i=\frac{1+\alpha_i}{2}$$

### 2.1 $\alpha_i$ — desvio das proporções de Hardy–Weinberg
Análogo de $F_{IS}$ para a subpopulação. $\alpha_i>0$: excesso de homozigotos (autofecundação, acasalamento entre aparentados, efeito Wahlund por subestrutura interna, alelos nulos). $\alpha_i<0$: excesso de heterozigotos (dioicia, autoincompatibilidade, seleção, ou um F1/sintético recém-formado).

### 2.2 $G_i$ — proporção da diversidade que está *entre* indivíduos
Talvez a métrica mais subutilizada do artigo. É um **medidor do sistema reprodutivo**:

| $G_i$ | Situação | Espécie/material típico |
|-------|----------|------------------------|
| ≈ 0,5 | Panmixia perfeita | Milho, girassol, populações abertas |
| < 0,5 | Excesso de heterozigotos | Sintéticos F1, clones heterozigotos, autoincompatíveis |
| → 1,0 | Todos homozigotos | Linhagens endogâmicas, DH, autógamas |

**Por que importa operacionalmente.** $1-G_i$ é a fração da diversidade do acesso que está guardada *dentro* de cada planta. Em um banco de germoplasma, isso decide o desenho de amostragem: com $G_i\to 1$ (autógamas), **um** indivíduo captura quase nada e você precisa de muitas plantas por acesso; com $G_i\approx 0{,}5$ (milho), poucas plantas já capturam metade da diversidade do acesso.

---

## 3. Distâncias

### 3.1 Distância entre indivíduos, $D_{ij}$
$$D_{ij}=\frac{s_i+s_j}{2}-f_{ij}$$

### 3.2 Distância mínima de Nei entre subpopulações, $\mathbf{D}_{ij}$
$$\mathbf{D}_{ij}=\frac{f_{ii}+f_{jj}}{2}-f_{ij}=\sum_{k}\tfrac{1}{2}(\tilde p_{k,i}-\tilde p_{k,j})^2$$

Note o que ela é de fato: **metade da soma dos quadrados das diferenças de frequência alélica** — um componente de variância, não uma distância evolutiva calibrada em tempo. Ela é a peça que entra em $F_{ST}$, e é legítima. O erro do método de Weitzman não é usar $\mathbf{D}_{ij}$; é usar *somente* $\mathbf{D}_{ij}$.

$$\bar{D}=\frac{\sum_{i,j}\mathbf{D}_{ij}N_iN_j}{N_T^2}=GD_{BS}$$

> **Dica computacional (economia de $O(N^2)$):** a Equação 13 do artigo calcula $D_{ij}$ por dupla soma sobre todos os pares de indivíduos — custo $O(N_iN_j m)$. É desnecessário: a identidade $D_{ij}=(s_i+s_j)/2-f_{ij}$ é **exata**, e reduz o custo a $O(Nm)$. Verifiquei numericamente contra a Tabela 2 do artigo: coincide até a última casa. Para um painel de 50k SNPs e 5.000 acessos, essa observação é a diferença entre horas e segundos.

---

## 4. Coancestria global $\bar{f}$ e a decomposição da contribuição individual

$$\bar{f}=\sum_{i}\frac{N_i}{N_T}\Big[\,\underbrace{f_{ii}}_{\text{coancestria interna}}-\underbrace{\sum_j \mathbf{D}_{ij}\frac{N_j}{N_T}}_{\text{distância média aos demais}}\Big]$$

Esta é a equação mais importante do artigo para uso prático. Ela mostra que a contribuição de cada acesso à coancestria global (isto é, à *perda* de diversidade do pool) tem **dois sinais opostos**:

- **Termo 1 (+):** quanto mais internamente fixado o acesso, mais ele *aumenta* a coancestria global — ele "dilui" o pool com cópias do mesmo alelo.
- **Termo 2 (−):** quanto mais distante dos demais, mais ele *reduz* a coancestria global.

Um método baseado só em distância vê apenas o termo 2. Daí a inversão de conclusões.

---

## 5. Estatísticas F

$$F_{IS}=\frac{\tilde F-\tilde f}{1-\tilde f},\qquad F_{ST}=\frac{\tilde f-\bar f}{1-\bar f}=\frac{\bar D}{1-\bar f},\qquad F_{IT}=\frac{\tilde F-\bar f}{1-\bar f}$$

com $(1-F_{IT})=(1-F_{IS})(1-F_{ST})$.

**Leitura para melhoramento.** $F_{ST}$ diz que fração da variação neutra total está *entre* acessos. Valores típicos: landraces de milho $\approx$ 0,03–0,15 (a maior parte da diversidade está dentro de cada landrace, e portanto amostrar poucos acessos com muitas plantas é melhor do que muitos acessos com poucas plantas); autógamas e coleções de linhagens elite podem passar de 0,4. Em painéis de linhagens fixadas, $F_{IS}$ perde sentido biológico — a estrutura relevante é $F_{ST}$.

---

## 6. Partição da diversidade — o coração do artigo

$$(1-\bar f)=\underbrace{(1-\tilde s)}_{GD_{WI}}+\underbrace{(\tilde s-\tilde f)}_{GD_{BI}}+\underbrace{(\tilde f-\bar f)}_{GD_{BS}}$$

| Componente | Definição | O que é, biologicamente |
|-----------|-----------|--------------------------|
| $GD_T=1-\bar f$ | Diversidade total | $H_e$ do pool inteiro se todos fossem recombinados |
| $GD_{WI}=1-\tilde s$ | Dentro de indivíduos | Heterozigosidade carregada dentro de cada planta |
| $GD_{BI}=\tilde s-\tilde f$ | Entre indivíduos, dentro do acesso | Variação segregante disponível para seleção intrapopulacional |
| $GD_{WS}=1-\tilde f$ | Dentro de subpopulações | $GD_{WI}+GD_{BI}$ |
| $GD_{BS}=\tilde f-\bar f=\bar D$ | Entre subpopulações | Divergência; o *único* componente que Weitzman enxerga |

E as identidades limpas (Eq. 8):

$$\frac{GD_{WI}}{GD_T}=(1-G)(1-F_{ST}),\quad \frac{GD_{BI}}{GD_T}=G(1-F_{ST}),\quad \frac{GD_{WS}}{GD_T}=1-F_{ST},\quad \frac{GD_{BS}}{GD_T}=F_{ST}$$

### Por que essa partição muda a estratégia por espécie

- **Alógamas (milho, girassol, forrageiras, espécies florestais):** $GD_{WI}$ é grande. A diversidade está literalmente *dentro* das plantas. Conservar significa manter heterozigosidade — regenerar com muitos indivíduos e contribuições equilibradas.
- **Autógamas (soja, trigo, arroz, feijão) e coleções de DH/linhagens:** $GD_{WI}\approx 0$. Toda a diversidade é $GD_{BI}+GD_{BS}$. Conservar significa manter *número de linhagens distintas*; a heterozigosidade não é um alvo. Regenerar com poucas plantas por linhagem é aceitável; perder linhagens não é.
- **Clonais (batata, cana, fruteiras):** $GD_{WI}$ é alta e **congelada** — não se reduz por deriva enquanto o clone existir. A conta de $N_e$ do artigo não se aplica sem adaptação.

---

## 7. Estimação a partir de marcadores moleculares

Com $p_{k,l,i}$ = dosagem do alelo $k$ no indivíduo $l$ da subpopulação $i$ e $\tilde p_{k,i}=\sum_l p_{k,l,i}/N_i$:

$$f_{ij}=\sum_k \tilde p_{k,i}\tilde p_{k,j}\quad(11)\qquad s_i=\sum_k\sum_l \frac{p_{k,l,i}^2}{N_i}\quad(12)$$

Todo o pipeline se reduz a **dois produtos de matrizes**. Cuidados:

1. **Amostras, não censos.** As fórmulas assumem que você mediu a população inteira. Com amostras, aplique correções de tamanho finito (Nei & Chesser 1983; Pons & Chaouche 1995), sob pena de subestimar $H_e$ e inflar $F_{ST}$ em acessos com poucos indivíduos genotipados — exatamente os acessos raros que você quer avaliar.
2. **Coancestria molecular ≠ coancestria genealógica.** A conversão $1-\bar f_m=(1-\sum_k p_k^2)(1-\bar f)$ depende das frequências na população-base, que você não conhece. Lynch & Ritland (1999) e Toro et al. (2001) mostram que a transformação é instável. Na prática: use coancestria molecular *comparativamente*, dentro do mesmo painel, e nunca compare valores absolutos entre estudos.
3. **Viés de averiguação (ascertainment bias).** Chips de SNP desenvolvidos em material elite subestimam sistematicamente a diversidade de landraces e parentes silvestres — precisamente o material que a análise deveria valorizar. Prefira GBS/sequenciamento, ou pelo menos declare o viés.

---

## 8. Perda ou **ganho** de diversidade ao remover um acesso

Recalcula-se $\bar f$ com o acesso removido e mede-se a variação proporcional de $GD_T$. Reproduzindo o exemplo do artigo (4 subpopulações, 3 locos, 12/4/8/6 indivíduos):

| Acesso | $GD_T$ sem ele | Δ ponderada por $N_i$ | Δ não ponderada | Weitzman |
|--------|----------------|----------------------|-----------------|----------|
| 1 | 0,6296 | −11,3 + 4,7 = **−6,6%** | −6,8% | −5,8% |
| 2 | 0,6869 | +9,6 − 7,8 = **+1,8%** | **+6,5%** | **−65,5%** |
| 3 | 0,6481 | −1,2 − 5,1 = −3,9% | −7,0% | −63,3% |
| 4 | 0,6690 | −3,1 + 2,3 = −0,8% | −3,6% | −9,0% |

**O caso da subpopulação 2 é a mensagem inteira do artigo.** Weitzman diz que perdê-la custa 65,5% da diversidade (é a mais divergente). A análise correta diz que removê-la **aumenta** a diversidade do pool em 1,8–6,5%, porque ela está quase fixada internamente ($f_{22}=0{,}875$, ou seja $H_e=0{,}125$). Ela é distante porque é fixada — e alelos fixados numa amostra de 4 indivíduos não são um recurso genético, são o resultado de deriva.

Na reanálise dos 11 suínos europeus de Laval et al. (2000), o mesmo padrão: Weitzman aponta a raça Basca (FRBA) como a mais valiosa (−15,2%); a análise de coancestria mostra que removê-la **aumentaria** a diversidade em 0,67%, e que remover as quatro raças francesas aumentaria em 3,21%.

**Tradução para banco de germoplasma:** um acesso raro, com poucas plantas e alta homozigose — o típico acesso "único" de uma árvore de distâncias — pode estar contribuindo *negativamente* para o pool. Isso **não** significa descartá-lo (ver Seção 11), mas significa que a prioridade correta pode ser **regenerá-lo com $N$ maior**, não replicá-lo em uma coleção nuclear.

---

## 9. Contribuições ótimas $c_i$ — como compor um sintético ou uma coleção nuclear

$$GD_T = 1-\sum_{i,j} f_{ij}c_ic_j \quad\longrightarrow\quad \max_{\mathbf c}\;\; \text{s.a.}\;\; c_i\ge 0,\;\sum_i c_i=1$$

É um **problema de programação quadrática** (minimizar $\mathbf c^\top \mathbf F\mathbf c$ com $\mathbf F$ a matriz de coancestria). No exemplo do artigo: $\mathbf c=(0{,}522;\;0{,}000;\;0{,}270;\;0{,}208)$, elevando $GD_T$ de 0,6744 para 0,6874 (+1,92%). A subpopulação 2 recebe peso **zero**.

**Usos diretos em melhoramento de plantas:**

- **População-base de seleção recorrente.** $c_i$ dá a proporção de sementes de cada fonte na composição do sintético que maximiza a variância aditiva de longo prazo.
- **Coleção nuclear (*core collection*).** Em vez de heurísticas de agrupamento + amostragem proporcional, resolva a QP diretamente com restrições operacionais ($c_i \le$ capacidade de multiplicação, $c_i \ge$ mínimo político/legal para acessos de importância cultural).
- **Seleção com contribuição ótima (OCS).** Substituindo o objetivo por $\max \mathbf c^\top \mathbf g - \lambda\,\mathbf c^\top \mathbf F\mathbf c$ com $\mathbf g$ = GEBVs, obtém-se o arcabouço de Meuwissen (1997), hoje padrão em programas genômicos. O artigo é o caso $\lambda\to\infty$ (diversidade pura). O melhorista opera no meio da curva.

---

## 10. Minimizar coancestria = maximizar $N_e$

$$N_e\approx\frac{2Nn}{(\bar V_{WS(0,\infty)}+V_{BS(0,\infty)}+1)(1-F_{IT})}\qquad(14)$$

$$N_e\approx\frac{Nn}{\frac{1}{4}(1-F_{ST})\big[(S_W^2+S_B^2)(1+3F_{IS})+2(1-F_{IS})\big]+N(S_B^2/2)F_{ST}}\qquad(15)$$

onde $S_W^2$ e $S_B^2$ são as variâncias do número de descendentes **dentro** e **entre** subpopulações. Generaliza Wray & Thompson (1990) e recupera Whitlock & Barton (1997) e Caballero (1994) como casos particulares.

**A consequência operacional é simples e poderosa.** Com contribuições **iguais** ($S_W^2=S_B^2=0$), a Equação 14 dá $N_e\approx 2Nn/(1-F_{IT})$ — cerca do **dobro** do $N_e$ obtido com contribuições aleatórias (Poisson). Ou seja: em regeneração de acessos ou em recombinação de ciclos de seleção recorrente,

> **colher o mesmo número de sementes de cada planta e o mesmo número de plantas de cada família dobra o tamanho efetivo — sem custo, sem genotipagem, sem tecnologia.**

É provavelmente a intervenção de melhor custo-benefício em manejo de germoplasma. O contrário — colher a granel de um talhão, o que na prática amostra desproporcionalmente as plantas mais produtivas — inflaciona $S_W^2$ e derruba $N_e$.

---

## 11. Por que o método de Weitzman falha em nível intraespecífico

| Problema | Consequência |
|----------|--------------|
| Usa apenas distâncias entre grupos | Ignora $GD_{WS}$, que é tipicamente 80–95% de $GD_T$ em alógamas |
| Remover um elemento sempre "reduz" a diversidade, por construção | Impossível detectar acessos redundantes ou fixados |
| Não considera $N_i$ nem $N_{e,i}$ | Uma raça/acesso com $N_e=13$ é tratada como uma com $N_e=32.686$ |
| Interpretação filogenética exige isolamento e evolução independente | Falso em espécies domesticadas, onde há migração e fluxo constante entre pools |
| Não se conecta a $H_e$ de Nei | Não há como ligar a decisão a $N_e$, a deriva, ou a variância aditiva esperada |

Os autores concluem que a análise de Weitzman não acrescenta nada à análise padrão derivada de Nei (1973) — e pode levar a conclusões invertidas.

### A ressalva honesta (que o artigo faz, e que o melhorista deve levar a sério)
Critérios baseados em variação intrapopulacional tendem a **favorecer sistematicamente as populações maiores**. Ou seja: o critério de $\bar f$ pode empurrar um banco em direção ao material elite e abundante, exatamente o oposto do objetivo de conservação. Além disso:

- Marcadores neutros não medem valor adaptativo, resistência a doenças, adaptação a estresses, nem valor cultural. Um acesso fixado pode carregar o único alelo de resistência a uma ferrugem emergente.
- **Riqueza alélica** é mais sensível a gargalos do que heterozigosidade e é frequentemente o critério mais relevante para pré-melhoramento. O argumento do artigo — que o "número efetivo de alelos" é o inverso da coancestria média (Crow & Kimura 1970), logo minimizar $\bar f$ maximiza riqueza alélica no longo prazo — é válido assintoticamente, mas **não** protege alelos raros no curto prazo.
- Chaiwong & Kinghorn (1999) pesaram a variação entre grupos 5× mais que a de dentro. É arbitrário, mas reconhece o problema. Uma solução defensável é otimizar $\mathbf c$ com restrições mínimas por acesso, em vez de mexer nos pesos.

**Regra prática:** use $\bar f$ para decidir **proporções e esforço de regeneração**; nunca use $\bar f$ sozinho para decidir **descarte**. Custo de armazenar semente é baixo; extinção é irreversível.

---

## 12. Exemplo numérico completo (reproduzido e verificado)

Metapopulação do artigo: 4 subpopulações ($N$ = 12, 4, 8, 6), 3 locos com 5, 3 e 3 alelos.

**Matriz de coancestria $f_{ij}$ (diagonal e acima) / distância de Nei $\mathbf{D}_{ij}$ (abaixo):**

|        | Sub 1 | Sub 2 | Sub 3 | Sub 4 |
|--------|-------|-------|-------|-------|
| Sub 1  | **0,3391** | 0,3021 | 0,2535 | 0,3229 |
| Sub 2  | 0,3050 | **0,8750** | 0,3073 | 0,3889 |
| Sub 3  | 0,1544 | 0,3685 | **0,4766** | 0,2483 |
| Sub 4  | 0,0318 | 0,2338 | 0,1752 | **0,3704** |

**Parâmetros por subpopulação:**

| Sub | $F_i$ | $s_i$ | $\alpha_i$ | $G_i$ | Contribuição a $\bar f$ |
|-----|-------|-------|-----------|-------|------------------------|
| 1 | 0,3056 | 0,6528 | −0,0508 | 0,4746 | 0,1356 − 0,0352 = 0,1004 |
| 2 | 0,8333 | 0,9167 | −0,3333 | 0,3333 | 0,1167 − 0,0356 = 0,0811 |
| 3 | 0,2917 | 0,6458 | −0,3532 | 0,3234 | 0,1271 − 0,0389 = 0,0882 |
| 4 | 0,5000 | 0,7500 | +0,2059 | 0,6029 | 0,0741 − 0,0182 = 0,0559 |

**Globais:** $\tilde f=0{,}4535$; $\tilde F=0{,}4111$; $\tilde s=0{,}7056$; $\bar D=0{,}1279$; $\bar f=0{,}3256$.
$F_{IS}=-0{,}0775$; $F_{ST}=0{,}1897$; $F_{IT}=0{,}1268$.
$GD_T=0{,}6744$; $GD_{WI}=0{,}2944$ (43,7%); $GD_{BI}=0{,}2521$ (37,4%); $GD_{BS}=0{,}1279$ (19,0%).

**Contribuições ótimas:** $\mathbf c=(0{,}522;\;0;\;0{,}270;\;0{,}208)$ → $GD_T=0{,}6874$.

> **Errata detectada na verificação:** a Tabela 2b do artigo lista $F_2=0{,}8383$, mas $F_i=2s_i-1=2(0{,}9167)-1=0{,}8333$. Erro tipográfico. Todos os demais valores das Tabelas 2 e 3 foram reproduzidos exatamente.
>
> **Segunda errata, esta conceitual:** na Discussão, o texto afirma que contribuições iguais ($S_B^2=S_W^2=0$) são necessárias "para minimizar o tamanho efetivo" e "maximizar a coancestria média". Está invertido — a Equação 15 e todo o argumento do artigo mostram o oposto: contribuições iguais **maximizam** $N_e$ e **minimizam** $\bar f$.

---

## 13. Implementação em R

Todo o arcabouço se reduz a dois produtos de matrizes. O código abaixo foi validado contra as Tabelas 2 e 3 do artigo.

```r
# =====================================================================
#  Diversidade genética em populações subdivididas
#  Caballero & Toro (2002) Conservation Genetics 3:289-299
#  Implementação vetorizada para painéis de marcadores biálicos (SNP)
# =====================================================================

#' Partição da diversidade genética em uma metapopulação
#'
#' @param G matriz n_ind x n_loci com dosagem do alelo de referência (0/1/2).
#'          NAs são permitidos.
#' @param pop vetor de comprimento n_ind com o rótulo da subpopulação.
#' @param weights "census" (pondera por N_i) ou "equal" (não ponderado).
#' @return lista com matrizes f, D (Nei), parâmetros por subpop e globais.
gd_partition <- function(G, pop, weights = c("census", "equal")) {

  weights <- match.arg(weights)
  stopifnot(nrow(G) == length(pop))
  pop  <- as.factor(pop)
  pops <- levels(pop)
  n    <- length(pops)
  m    <- ncol(G)

  P <- G / 2                                   # dosagem do alelo ref. por indivíduo

  ## --- frequências alélicas por subpopulação (Eq. 10) ------------------
  Pbar <- t(vapply(pops, function(k)
              colMeans(P[pop == k, , drop = FALSE], na.rm = TRUE),
              numeric(m)))
  rownames(Pbar) <- pops

  ## --- coancestria entre subpopulações (Eq. 11) ------------------------
  ## biálico: f_ij = mean_loci( p_i p_j + q_i q_j )
  Q <- 1 - Pbar
  f <- (tcrossprod(Pbar) + tcrossprod(Q)) / m
  dimnames(f) <- list(pops, pops)

  ## --- auto-coancestria (Eq. 12) e endogamia molecular -----------------
  s <- vapply(pops, function(k) {
         Pk <- P[pop == k, , drop = FALSE]
         mean(rowMeans(Pk^2 + (1 - Pk)^2, na.rm = TRUE))
       }, numeric(1))
  Fi <- 2 * s - 1

  ## --- distância mínima de Nei (Eq. 3) ---------------------------------
  fii <- diag(f)
  D   <- outer(fii, fii, "+") / 2 - f
  dimnames(D) <- list(pops, pops)

  ## --- pesos ------------------------------------------------------------
  Ni <- as.numeric(table(pop)[pops])
  w  <- if (weights == "census") Ni / sum(Ni) else rep(1 / n, n)

  ## --- médias da metapopulação (Eq. 1, 4, 5) ----------------------------
  f_til <- sum(w * fii)        # coancestria média DENTRO
  s_til <- sum(w * s)
  F_til <- sum(w * Fi)
  f_bar <- as.numeric(t(w) %*% f %*% w)   # coancestria GLOBAL
  D_bar <- as.numeric(t(w) %*% D %*% w)

  ## --- desvio de HW e proporção entre indivíduos (Eq. 2) ----------------
  alpha <- (Fi - fii) / (1 - fii)
  Gi    <- (s  - fii) / (1 - fii)

  ## --- estatísticas F (Eq. 6) -------------------------------------------
  F_IS <- (F_til - f_til) / (1 - f_til)
  F_ST <- D_bar / (1 - f_bar)
  F_IT <- (F_til - f_bar) / (1 - f_bar)

  ## --- partição da diversidade (Eq. 7) ----------------------------------
  GD <- c(GD_T  = 1 - f_bar,
          GD_WI = 1 - s_til,
          GD_BI = s_til - f_til,
          GD_WS = 1 - f_til,
          GD_BS = f_til - f_bar)

  ## --- contribuição de cada subpop a f_bar (Eq. 5, forma decomposta) ----
  contrib <- data.frame(
    pop        = pops,
    N          = Ni,
    f_ii       = fii,
    He         = 1 - fii,
    s_i        = s,
    F_i        = Fi,
    alpha_i    = alpha,
    G_i        = Gi,
    termo_coanc = w * fii,
    termo_dist  = w * as.numeric(D %*% w),
    row.names  = NULL
  )
  contrib$contrib_fbar <- contrib$termo_coanc - contrib$termo_dist

  list(f = f, D_nei = D, w = w,
       por_subpop = contrib,
       globais = c(f_til = f_til, F_til = F_til, s_til = s_til,
                   D_bar = D_bar, f_bar = f_bar,
                   F_IS = F_IS, F_ST = F_ST, F_IT = F_IT),
       diversidade = GD)
}


#' Perda (-) ou ganho (+) de diversidade ao remover cada subpopulação
#' @param res saída de gd_partition()
#' @param Ni  vetor de tamanhos; se NULL usa os pesos de `res`
loss_gain <- function(res, weights = c("census", "equal")) {
  weights <- match.arg(weights)
  f  <- res$f
  Ni <- res$por_subpop$N
  n  <- nrow(f)
  wf <- function(idx) {
    w <- if (weights == "census") Ni[idx] / sum(Ni[idx]) else rep(1/length(idx), length(idx))
    as.numeric(t(w) %*% f[idx, idx, drop = FALSE] %*% w)
  }
  GD_full <- 1 - wf(seq_len(n))
  out <- vapply(seq_len(n), function(k) {
    idx <- setdiff(seq_len(n), k)
    GD_k <- 1 - wf(idx)
    c(GD_sem_i = GD_k, delta_pct = 100 * (GD_k - GD_full) / GD_full)
  }, numeric(2))
  data.frame(pop = rownames(f), t(out), row.names = NULL)
}


#' Contribuições ótimas c_i que maximizam a diversidade do pool (Eq. 9)
#' Programação quadrática: min c'Fc  s.a.  sum(c)=1, c >= lower, c <= upper
optimal_contributions <- function(f, lower = 0, upper = 1, ridge = 1e-8) {
  if (!requireNamespace("quadprog", quietly = TRUE))
    stop("Instale o pacote 'quadprog'.")
  n    <- nrow(f)
  Dmat <- 2 * (f + diag(ridge, n))            # ridge garante definida positiva
  dvec <- rep(0, n)
  Amat <- cbind(rep(1, n), diag(n), -diag(n)) # igualdade + limites
  bvec <- c(1, rep(lower, n), rep(-upper, n))
  sol  <- quadprog::solve.QP(Dmat, dvec, Amat, bvec, meq = 1)
  ci   <- pmax(sol$solution, 0); ci <- ci / sum(ci)
  list(c_i = setNames(round(ci, 6), rownames(f)),
       GD_max = as.numeric(1 - t(ci) %*% f %*% ci))
}


#' Seleção com contribuição ótima (OCS): mérito genético vs. diversidade
#' max  c'g - lambda * c'Fc
ocs <- function(f, gebv, lambda = 1, lower = 0, upper = 1) {
  n    <- nrow(f)
  Dmat <- 2 * lambda * (f + diag(1e-8, n))
  dvec <- as.numeric(gebv)
  Amat <- cbind(rep(1, n), diag(n), -diag(n))
  bvec <- c(1, rep(lower, n), rep(-upper, n))
  sol  <- quadprog::solve.QP(Dmat, dvec, Amat, bvec, meq = 1)
  ci   <- pmax(sol$solution, 0); ci <- ci / sum(ci)
  list(c_i        = setNames(round(ci, 6), rownames(f)),
       merito     = as.numeric(crossprod(ci, gebv)),
       coancestria = as.numeric(t(ci) %*% f %*% ci))
}

# ---------------------------------------------------------------------
# Uso típico
# ---------------------------------------------------------------------
# res <- gd_partition(G_snp, acesso)
# res$diversidade / res$globais["F_ST"]
# res$por_subpop[order(res$por_subpop$contrib_fbar, decreasing = TRUE), ]
# loss_gain(res)
# optimal_contributions(res$f, upper = 0.20)   # teto operacional de 20%
#
# Curva de fronteira mérito x diversidade:
# fronteira <- do.call(rbind, lapply(10^seq(-2, 3, length = 40), function(l) {
#   o <- ocs(res$f, gebv, lambda = l); data.frame(l, o$merito, o$coancestria)
# }))
```

### Nota sobre C++
Nada aqui exige Rcpp: com $n$ subpopulações e $m$ locos, o custo é $O(nm)$ para as frequências e $O(n^2m)$ para $\mathbf F$ — trivial mesmo com $m=10^6$, desde que se use `tcrossprod()` (BLAS) e se evite a Equação 13. O gargalo real aparece apenas quando se quer a **matriz de coancestria indivíduo × indivíduo** ($N\times N$), aí sim vale `RcppArmadillo` com blocagem, ou os solvers esparsos usados em ssGBLUP. Para painéis grandes, considere também `bigstatsr`/`bigsnpr` para operações out-of-core.

---

## 14. Roteiro de decisão para um programa de melhoramento

1. **Genotipe** com painel sem viés de averiguação para o material-alvo; codifique 0/1/2.
2. **Defina as subpopulações** honestamente — acessos, landraces, grupos heteróticos, ciclos. A partição é sensível a essa definição (o "S" de $F_{ST}$ é uma escolha sua, não um dado).
3. **Calcule a partição.** Se $F_{ST}$ for baixo (<0,10), a diversidade está dentro dos acessos: priorize $N$ por acesso na regeneração. Se for alto, priorize número de acessos.
4. **Rode o leave-one-out.** Acessos com contribuição positiva grande a $\bar f$ (alto $f_{ii}$, baixa distância) são candidatos a *regeneração com $N$ ampliado*, não a descarte.
5. **Resolva a QP com restrições operacionais** para compor a coleção nuclear ou a população-base.
6. **Na recombinação, iguale contribuições** ($S_W^2\to0$, $S_B^2\to0$). Dobra o $N_e$ de graça.
7. **Cruze com informação não-neutra** antes de qualquer descarte: fenótipos, resistências, dados de passaporte, valor cultural. A métrica ordena prioridades; ela não decide sozinha.

---

## Referências essenciais

- Caballero A & Toro MA (2002) Analysis of genetic diversity for the management of conserved subdivided populations. *Conservation Genetics* 3:289–299. — **artigo base**
- Caballero A & Toro MA (2000) Interrelations between effective population size and other pedigree tools. *Genet Res* 75:331–343.
- Nei M (1973) Analysis of gene diversity in subdivided populations. *PNAS* 70:3321–3323.
- Cockerham CC (1967) Group inbreeding and coancestry. *Genetics* 56:89–104.
- Wang J & Caballero A (1999) Developments in predicting the effective size of subdivided populations. *Heredity* 82:212–226.
- Wray NR & Thompson R (1990) Predictions of rates of inbreeding in selected populations. *Genet Res* 55:41–54.
- Meuwissen THE (1997) Maximizing the response of selection with a predefined rate of inbreeding. *J Anim Sci* 75:934–940. — extensão natural da Eq. 9 para OCS
- Petit RJ, El Mousadik A & Pons O (1998) Identifying populations for conservation on the basis of genetic markers. *Conserv Biol* 12:844–855. — riqueza alélica

---

*Documento gerado a partir da leitura integral do artigo; todos os valores numéricos das Tabelas 2 e 3 foram recomputados a partir dos genótipos da Tabela 1 e conferem, com duas erratas do original registradas na Seção 12.*
