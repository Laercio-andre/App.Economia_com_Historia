// src/main/java/com/economiangola/dto/request/CriarForumRespostaRequest.java
package com.economiangola.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CriarForumRespostaRequest {

    @NotBlank(message = "O corpo da resposta é obrigatório")
    private String corpo;

    private Long paiId;
}
