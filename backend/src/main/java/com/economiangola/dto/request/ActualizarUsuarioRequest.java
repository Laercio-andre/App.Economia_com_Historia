// src/main/java/com/economiangola/dto/request/ActualizarUsuarioRequest.java
package com.economiangola.dto.request;

import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActualizarUsuarioRequest {

    @Size(min = 2, max = 120, message = "O nome deve ter entre 2 e 120 caracteres")
    private String nome;

    @Size(max = 500, message = "A bio não pode exceder 500 caracteres")
    private String bio;

    @Size(max = 500, message = "A URL do avatar não pode exceder 500 caracteres")
    private String avatarUrl;
}
