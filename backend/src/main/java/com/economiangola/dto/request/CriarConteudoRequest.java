// src/main/java/com/economiangola/dto/request/CriarConteudoRequest.java
package com.economiangola.dto.request;

import com.economiangola.domain.enums.TipoMidia;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CriarConteudoRequest {

    @NotBlank(message = "O título é obrigatório")
    private String titulo;

    private String resumo;

    private String corpo;

    @NotNull(message = "A categoria é obrigatória")
    private Long categoriaId;

    private List<MidiaDto> midias;

    private List<String> tags;

    @Getter
    @Setter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MidiaDto {
        @NotNull(message = "O tipo de mídia é obrigatório")
        private TipoMidia tipoMidia;

        @NotBlank(message = "A URL da mídia é obrigatória")
        private String url;

        private String titulo;
        private String descricao;
        private Integer ordem;
    }
}
