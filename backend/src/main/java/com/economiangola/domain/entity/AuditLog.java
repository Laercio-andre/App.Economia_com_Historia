// src/main/java/com/economiangola/domain/entity/AuditLog.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
@Table(name = "audit_logs")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuditLog extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;

    @Column(name = "accao", nullable = false, length = 100)
    private String accao;

    @Column(name = "entidade_tipo", nullable = false, length = 100)
    private String entidadeTipo;

    @Column(name = "entidade_id")
    private Long entidadeId;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "detalhes", columnDefinition = "JSON")
    private String detalhes;
}
