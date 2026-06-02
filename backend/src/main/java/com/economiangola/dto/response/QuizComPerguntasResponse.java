// src/main/java/com/economiangola/dto/response/QuizComPerguntasResponse.java
package com.economiangola.dto.response;

import com.economiangola.domain.enums.Dificuldade;
import com.economiangola.domain.enums.TipoPergunta;
import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuizComPerguntasResponse {

    private Long id;
    private String titulo;
    private String descricao;
    private Dificuldade dificuldade;
    private Integer tempoLimiteSeg;
    private Integer pontuacaoMaxima;
    private List<PerguntaResponse> perguntas;

    @Getter @Setter @Builder @NoArgsConstructor @AllArgsConstructor
    public static class PerguntaResponse {
        private Long id;
        private String texto;
        private TipoPergunta tipoPergunta;
        private Integer pontos;
        private Integer ordem;
        private List<OpcaoResponse> opcoes;
    }

    @Getter @Setter @Builder @NoArgsConstructor @AllArgsConstructor
    public static class OpcaoResponse {
        private Long id;
        private String texto;
        private Integer ordem;
        // Nota: NÃO inclui o campo "correta" — usado ao iniciar quiz
    }
}
