// src/main/java/com/economiangola/dto/request/CriarComentarioRequest.java
package com.economiangola.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CriarComentarioRequest {

    @NotBlank(message = "O texto do comentário é obrigatório")
    @Size(max = 2000, message = "O comentário não pode exceder 2000 caracteres")
    private String texto;

    private Long paiId;
}
