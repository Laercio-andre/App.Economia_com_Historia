// src/main/java/com/economiangola/dto/response/ConteudoResponse.java
package com.economiangola.dto.response;

import com.economiangola.domain.enums.StatusConteudo;
import com.economiangola.domain.enums.TipoMidia;
import lombok.*;

import java.time.Instant;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConteudoResponse {

    private Long id;
    private String titulo;
    private String slug;
    private String resumo;
    private String corpo;
    private StatusConteudo status;
    private Long visualizacoes;
    private AutorResumo autor;
    private CategoriaResumo categoria;
    private List<MidiaResponse> midias;
    private List<String> tags;
    private long totalReacoes;
    private long totalComentarios;
    private Instant criadoEm;
    private Instant actualizadoEm;

    @Getter @Setter @Builder @NoArgsConstructor @AllArgsConstructor
    public static class AutorResumo {
        private Long id;
        private String nome;
        private String avatarUrl;
    }

    @Getter @Setter @Builder @NoArgsConstructor @AllArgsConstructor
    public static class CategoriaResumo {
        private Long id;
        private String nome;
        private String slug;
    }

    @Getter @Setter @Builder @NoArgsConstructor @AllArgsConstructor
    public static class MidiaResponse {
        private Long id;
        private TipoMidia tipoMidia;
        private String url;
        private String titulo;
        private String descricao;
        private Integer ordem;
    }
}
