// src/main/java/com/economiangola/dto/response/QuizResponse.java
package com.economiangola.dto.response;

import com.economiangola.domain.enums.Dificuldade;
import lombok.*;

import java.time.Instant;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuizResponse {

    private Long id;
    private String titulo;
    private String slug;
    private String descricao;
    private Dificuldade dificuldade;
    private Integer tempoLimiteSeg;
    private Integer maxTentativas;
    private Integer pontuacaoMaxima;
    private Integer totalPerguntas;
    private ConteudoResponse.AutorResumo autor;
    private ConteudoResponse.CategoriaResumo categoria;
    private Instant criadoEm;
}
