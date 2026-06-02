// src/main/java/com/economiangola/dto/response/ResultadoQuizResponse.java
package com.economiangola.dto.response;

import lombok.*;

import java.time.Instant;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResultadoQuizResponse {

    private Long id;
    private Long quizId;
    private String quizTitulo;
    private Integer pontuacaoObtida;
    private Integer pontuacaoMaxima;
    private Double percentualAcerto;
    private Integer tempoGastoSeg;
    private Integer tentativaNum;
    private Boolean concluido;
    private List<RespostaDetalhe> respostas;
    private List<ConquistaResponse> conquistasDesbloqueadas;
    private Instant criadoEm;

    @Getter @Setter @Builder @NoArgsConstructor @AllArgsConstructor
    public static class RespostaDetalhe {
        private Long perguntaId;
        private String perguntaTexto;
        private Long opcaoEscolhidaId;
        private String opcaoEscolhidaTexto;
        private Long opcaoCorretaId;
        private String opcaoCorretaTexto;
        private Boolean correta;
        private String explicacao;
    }
}
