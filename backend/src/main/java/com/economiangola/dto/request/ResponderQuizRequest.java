// src/main/java/com/economiangola/dto/request/ResponderQuizRequest.java
package com.economiangola.dto.request;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResponderQuizRequest {

    @NotNull(message = "As respostas são obrigatórias")
    @NotEmpty(message = "A lista de respostas não pode estar vazia")
    private List<RespostaItemDto> respostas;

    private Integer tempoGastoSeg;

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RespostaItemDto {
        @NotNull(message = "O ID da pergunta é obrigatório")
        private Long perguntaId;

        @NotNull(message = "O ID da opção é obrigatório")
        private Long opcaoId;
    }
}
