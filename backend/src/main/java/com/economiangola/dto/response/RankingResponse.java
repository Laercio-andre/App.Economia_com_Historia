// src/main/java/com/economiangola/dto/response/RankingResponse.java
package com.economiangola.dto.response;

import com.economiangola.domain.enums.TipoRanking;
import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RankingResponse {

    private Long id;
    private String nome;
    private TipoRanking tipoRanking;
    private List<EntradaResponse> entradas;

    @Getter @Setter @Builder @NoArgsConstructor @AllArgsConstructor
    public static class EntradaResponse {
        private Integer posicao;
        private Integer pontos;
        private Long usuarioId;
        private String usuarioNome;
        private String usuarioAvatarUrl;
    }
}
