// src/main/java/com/economiangola/dto/request/CriarForumTopicoRequest.java
package com.economiangola.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CriarForumTopicoRequest {

    @NotBlank(message = "O título é obrigatório")
    private String titulo;

    @NotBlank(message = "O corpo é obrigatório")
    private String corpo;

    @NotNull(message = "A categoria é obrigatória")
    private Long categoriaId;

    private Long conteudoId;
}
