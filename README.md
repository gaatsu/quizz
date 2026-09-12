# Viper HUD

Um watch face para **Wear OS** no estilo do HUD de um caça dos anos 80–90.
Fósforo verde sobre preto absoluto, marcador de trajetória no centro, escada de
arfagem que inclina com o punho e fita de minutos no topo.

Abaixo de **15% de bateria** a escada de arfagem se apaga e entra o aviso de
colisão com o solo: chevrons de subida e a caixa **PULL UP** piscando em âmbar —
do mesmo jeito que um GCAS limpa o HUD no avião de verdade.

![Viper HUD](watchface/src/main/res/drawable/preview.png)

## Como é feito

Escrito em **Watch Face Format v1** (WFF) — XML declarativo, sem uma linha de
Kotlin. É o formato que o Google exige para watch faces novas na Play Store, e
o sistema renderiza tudo nativamente, sem um processo do app rodando. O arquivo
inteiro é [`watchface/src/main/res/raw/watchface.xml`](watchface/src/main/res/raw/watchface.xml).

| | |
|---|---|
| Formato | Watch Face Format v1 |
| Compatibilidade | Wear OS 4 e acima (`minSdk 33`) |
| Tela virtual | 450 × 450, recortada em círculo |
| Tipografia | [B612 Mono](https://github.com/polarsys/b612) — a fonte que a Airbus encomendou para displays de cockpit (OFL, embarcada no APK) |

### O que está na tela

| Elemento | Fonte de dado |
|---|---|
| Hora | `[HOUR_0_23_Z]` ou `[HOUR_1_12_Z]` conforme `[IS_24_HOUR_MODE]`, com `[MINUTE_Z]` |
| Segundos | `[SECOND_Z]`, pequenos e elevados como um readout de altitude |
| Data | `[DAY_OF_WEEK_S]` `[DAY_Z]` `[MONTH_S]`, em caixa alta |
| Fita de minutos | `[MINUTE]` — cinco marcas de um minuto, a atual sob o índice |
| Caixa STEP | `[STEP_COUNT]`, ou `--` se a permissão não estiver concedida |
| Caixa BATT | `[BATTERY_PERCENT]` |
| Escada de arfagem | `[ACCELEROMETER_ANGLE_Y]` e `[ACCELEROMETER_ANGLE_X]` via `Gyro` |
| Aviso PULL UP | `[BATTERY_PERCENT] <= 15`, piscando com `[SECOND] % 2` |

### Modo ambiente

Fica só o marcador de trajetória, a hora e a data, em verde apagado — sem fita,
sem escada, sem caixas, sem segundos. O PULL UP continua aparecendo, mas **parado**:
em ambiente a tela só redesenha uma vez por minuto, então um pisca de 1 Hz
congelaria em um estado qualquer.

## Rodando

Precisa do Android Studio com o SDK 35 e um relógio (ou emulador) com Wear OS 4+.

```bash
./gradlew :watchface:installDebug
```

Depois é só escolher o watch face na lista do relógio. Para testar o PULL UP sem
esperar a bateria acabar, num emulador:

```bash
adb shell dumpsys battery set level 10
adb shell dumpsys battery reset   # volta ao normal
```

A permissão de contagem de passos (`ACTIVITY_RECOGNITION`) é pedida na
instalação. Sem ela a caixa STEP mostra `--` e o resto funciona igual.

## Publicando

O `build.gradle.kts` do módulo ainda aponta para a chave de debug. Antes de subir
para a Play Store, troque por uma chave própria e mantenha
`isShrinkResources = false`: o XML do formato referencia as fontes e o preview
pelo nome, e o shrinker não enxerga esse uso.

## Estado

O XML foi validado contra o schema oficial do Watch Face Format v1
(os XSDs de [`google/watchface`](https://github.com/google/watchface)) — zero erros
de elemento, atributo, enum ou aninhamento. O que nenhuma validação estática pega
é o comportamento em hardware: a inclinação da escada depende de como o
acelerômetro está orientado no relógio. Se ela girar no eixo errado ou invertida,
troque `ACCELEROMETER_ANGLE_Y` por `ACCELEROMETER_ANGLE_X` no elemento `Gyro` —
há um comentário no XML marcando o lugar.

### Ideias para depois

- **Complications** nas caixas STEP e BATT, para escolher o que aparece ali.
- **Cores configuráveis** — âmbar e azul gelo além do verde, via `ColorConfiguration`.
- **WFF v2** liberaria `letterSpacing`, que deixaria os rótulos mais próximos de
  um placard de cockpit (custo: sobe o mínimo para Wear OS 5).
