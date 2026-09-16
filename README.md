# Viper HUD

Um watch face para **Wear OS** no estilo do HUD de um caça dos anos 80–90.
Fósforo verde sobre preto absoluto, marcador de trajetória no centro, escada de
arfagem que inclina com o punho, fita de minutos no topo e a temperatura do
tempo à esquerda. Notificação não lida acende uma antena de datalink embaixo.

Abaixo de **15% de bateria** a escada de arfagem se apaga e entra o aviso de
colisão com o solo: chevrons de subida e a caixa **PULL UP** piscando em âmbar —
do mesmo jeito que um GCAS limpa o HUD no avião de verdade.

![Viper HUD](watchface/src/main/res/drawable/preview.png)

## Como é feito

Escrito em **Watch Face Format** (WFF) — XML declarativo, sem uma linha de
Kotlin. É o formato que o Google exige para watch faces novas na Play Store, e
o sistema renderiza tudo nativamente, sem um processo do app rodando. O arquivo
inteiro é [`watchface/src/main/res/raw/watchface.xml`](watchface/src/main/res/raw/watchface.xml).

| | |
|---|---|
| Formato | Watch Face Format v4 |
| Compatibilidade | Wear OS 6 e acima (`minSdk 36`) |
| Tela virtual | 450 × 450, recortada em círculo |
| Tipografia | [B612 Mono](https://github.com/polarsys/b612) — a fonte que a Airbus encomendou para displays de cockpit (OFL, embarcada no APK) |

### Por que v4

A versão do formato **não é nível de otimização** — é um piso de
compatibilidade. Cada número exige um Wear OS mais novo e destrava recursos; o
renderizador é o mesmo. A regra saudável é ficar na menor versão que tenha o
que você usa, e aqui a conta fecha em v4:

| WFF | Wear OS mínimo | API | O que este arquivo usa dela |
|---|---|---|---|
| 1 | 4 | 33 | toda a base: HUD, escada, `Gyro`, `Condition` |
| 2 | 5 | 34 | `[WEATHER.*]` na caixa TEMP |
| 3 | 5.1 | 35 | `blendMode="PLUS"`, para o brilho somar como fósforo de verdade |
| 4 | 6 | 36 | `Variant` com `duration`/`interpolation`: a troca para o modo ambiente suaviza em vez de cortar |

A v5 existe nos schemas do Google, mas **não está na tabela de compatibilidade**
— não há Wear OS público que a execute, então declará-la deixaria o watch face
sem instalar em lugar nenhum.

### O que está na tela

| Elemento | Fonte de dado |
|---|---|
| Hora | `[HOUR_0_23_Z]` ou `[HOUR_1_12_Z]` conforme `[IS_24_HOUR_MODE]`, com `[MINUTE_Z]` |
| Segundos | `[SECOND_Z]`, pequenos e elevados como um readout de altitude |
| Data | `[DAY_OF_WEEK_S]` `[DAY_Z]` `[MONTH_S]`, em caixa alta |
| Fita de minutos | `[MINUTE]` — cinco marcas de um minuto, a atual sob o índice |
| Caixa TEMP | `[WEATHER.TEMPERATURE]` com a unidade de `[WEATHER.TEMPERATURE_UNIT]`, atrás de um teste de `[WEATHER.IS_AVAILABLE]` |
| Caixa BATT | `[BATTERY_PERCENT]` |
| Antena de datalink | `[UNREAD_NOTIFICATION_COUNT]`, só desenhada quando há algo não lido |
| Escada de arfagem | `[ACCELEROMETER_ANGLE_Y]` e `[ACCELEROMETER_ANGLE_X]` via `Gyro` |
| Aviso PULL UP | `[BATTERY_PERCENT] <= 15`, piscando com `[SECOND] % 2` |

Nenhuma permissão é pedida na instalação. O clima vem do sistema, não do app.

### Modo ambiente

Fica só o marcador de trajetória, a hora e a data, em verde apagado — sem fita,
sem escada, sem caixas, sem segundos. O PULL UP continua aparecendo, mas **parado**:
em ambiente a tela só redesenha uma vez por minuto, então um pisca de 1 Hz
congelaria em um estado qualquer.

## Rodando

Precisa do Android Studio com o SDK 36 e um relógio (ou emulador) com Wear OS 6+.

```bash
./gradlew :watchface:installDebug
```

Depois é só escolher o watch face na lista do relógio.

**Clima.** O relógio só sabe a temperatura se souber onde está, e para isso ele
usa o celular pareado ou a rede — nunca o GPS de bordo, para poupar bateria. Num
emulador solto, sem celular pareado, a caixa TEMP fica em `--` até você simular
uma localização:

```bash
adb shell cmd location set-location-enabled true
adb shell cmd location providers add-test-provider gps
adb shell cmd location providers set-test-provider-enabled gps true
adb shell cmd location providers set-test-provider-location gps --location -25.5163,-54.5854
```

**PULL UP.** Para ver o aviso sem esperar a bateria acabar:

```bash
adb shell dumpsys battery set level 10
adb shell dumpsys battery reset   # volta ao normal
```

## Publicando

O `build.gradle.kts` do módulo ainda aponta para a chave de debug. Antes de subir
para a Play Store, troque por uma chave própria e mantenha
`isShrinkResources = false`: o XML do formato referencia as fontes e o preview
pelo nome, e o shrinker não enxerga esse uso.

## Estado

O XML foi validado contra o schema oficial do formato (os XSDs de
[`google/watchface`](https://github.com/google/watchface), com um validador XSD
1.1) — zero erros de elemento, atributo, enum ou aninhamento. Como o schema
trata expressão como texto livre, ele **não** verifica se uma fonte de dado
existe na versão declarada; por isso cada uma das 16 fontes usadas aqui foi
cruzada à parte com os enums das cinco versões da spec, junto com os atributos
que também puxam o piso (`blendMode` e o `Variant` animado). O resultado bateu
com a v4 do manifesto.

O que nenhuma validação estática pega é o comportamento em hardware. Um ponto
merece atenção no primeiro teste: a inclinação da escada depende de como o
acelerômetro está orientado no relógio. Se ela girar no eixo errado ou
invertida, troque `ACCELEROMETER_ANGLE_Y` por `ACCELEROMETER_ANGLE_X` no
elemento `Gyro` — há um comentário no XML marcando o lugar.

### Sobre o ponto laranja

O indicador de notificação do sistema é desenhado **por cima** do watch face.
Nenhum formato de watch face consegue trocar, mover ou esconder ele — a antena
daqui é um segundo indicador, não um substituto. Quem desliga o ponto é o dono
do relógio, nas configurações de notificação.

Também não existe gatilho de "chegou notificação" no formato: os eventos são
`TAP`, `ON_VISIBLE` e `ON_NEXT_SECOND`/`MINUTE`/`HOUR`. Dá para pulsar a antena
continuamente enquanto houver não lidas, mas isso obriga o mostrador a
redesenhar a cada segundo, e por isso ela é estática.

### Ideias para depois

- **Complications** nas caixas TEMP e BATT, para escolher o que aparece ali.
- **Cores configuráveis** — âmbar e azul gelo além do verde, via `ColorConfiguration`.
- **`letterSpacing`** nos rótulos: deixaria TEMP e BATT mais perto de um
  placard de cockpit. Disponível desde a v2, ainda não aplicado.
