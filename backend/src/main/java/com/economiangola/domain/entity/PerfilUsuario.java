// src/main/java/com/economiangola/domain/entity/PerfilUsuario.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "perfis_usuario", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"usuario_id", "tipo_perfil_id"})
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PerfilUsuario extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tipo_perfil_id", nullable = false)
    private TipoPerfil tipoPerfil;
}
